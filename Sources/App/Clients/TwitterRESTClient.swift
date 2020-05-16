//
//  TwitterClient.swift
//  App
//
//  Created by Victor Lewis on 5/2/20.
//

import Vapor

class TwitterRESTClient : Service {
    private let authToken : String
    var httpClient : Client
    
    let jsonDecoder : JSONDecoder
    let logger : Logger
    let eventLoop : EventLoop
    
    init(_ client : Client, _ logger : Logger) throws {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let apiToken = Environment.get("TWITTER_TOKEN") else {
            throw Abort(.internalServerError, reason: "Mising env variable TWITTER_TOKEN")
        }
        
        authToken =  "Bearer " + apiToken
        
        self.logger = logger
                
        self.httpClient = client
        
        self.eventLoop = httpClient.container.eventLoop
    }
    
    private func statusIsOK(_ code : UInt) -> Bool {
        return code > 199 && code < 300
    }
    
    private func _followers(of screenName : String, nextCursor : Int64 = -1) throws -> Future<TwitterCursor>{
        logger.debug("Fetching followers of \(screenName) cursor \(nextCursor)")
        let res = httpClient.get("https://api.twitter.com/1.1/followers/ids.json?screen_name=\(screenName)&cursor=\(nextCursor)&count=5000", headers: ["authorization": authToken])
        return res.flatMap { res in
            guard self.statusIsOK(res.http.status.code) else {
                throw Abort(res.http.status, reason: res.http.status.reasonPhrase)
            }
            return try res.content.decode(TwitterCursor.self, using: self.jsonDecoder).map {
                self.logger.debug("Reply contained \($0.ids.count) ids")
                return $0
            }
        }
    }
    
    private func _followersFetcher(of screenName : String, nextCursor : Int64 = -1, users: Set<Int64> = []) throws -> Future<TwitterCursor> {
        return try _followers(of: screenName, nextCursor: nextCursor).flatMap { userCursor in
            let newUsers = users.union(userCursor.ids)
            if userCursor.nextCursor > 0 {
                return try self._followersFetcher(of: screenName, nextCursor: userCursor.nextCursor, users: newUsers).map {$0}
            }
            return self.eventLoop.future(TwitterCursor(ids: newUsers))
        }
    }
    
    func fetchFollwers(of screenName : String) throws -> Future<Set<Int64>> {
        return try _followersFetcher(of: screenName).map{$0.ids}
    }
    
    private func _lookupUsers(of ids : [Int64]) throws -> Future<Set<User>> {
        let idsAsString = ids.map{String($0)}.joined(separator: ",")
        logger.debug("Fetching user info for \(ids.count) ids")
        let res = httpClient.get("https://api.twitter.com/1.1/users/lookup.json?user_id=\(idsAsString)", headers: ["authorization": authToken])
        return res.flatMap { res in
            guard self.statusIsOK(res.http.status.code) else {
                throw Abort(res.http.status, reason: res.http.status.reasonPhrase)
            }
            return try res.content.decode(Set<User>.self, using: self.jsonDecoder)
        }
    }
    
    func lookupUsers(userIds ids : Set<Int64>) throws -> Future<Set<User>> {
        var lookupSubset : [Int64] = []
        var result : Future<Set<User>> = eventLoop.future([])
        for id in ids {
            lookupSubset.append(id)
            if lookupSubset.count == 100 {
                result =  try _lookupUsers(of: lookupSubset).and(result).map { (set1, set2) in
                    set1.union(set1)
                }
                lookupSubset = []
            }
        }
        if  lookupSubset.count != 0 {
            result =  try _lookupUsers(of: lookupSubset).and(result).map { (set1, set2) in
                set1.union(set1)
            }
        }
        return result
    }
}
