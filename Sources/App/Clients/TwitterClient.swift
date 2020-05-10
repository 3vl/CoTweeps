//
//  TwitterClient.swift
//  App
//
//  Created by Victor Lewis on 5/2/20.
//

import Vapor

class TwitterClient : Service {
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
    
    private func _followers(of screenName : String, nextCursor : Int64 = -1) throws -> Future<UserCursor>{
        logger.debug("Fetching followers of \(screenName) cursor \(nextCursor)")
        let res = httpClient.get("https://api.twitter.com/1.1/followers/list.json?screen_name=\(screenName)&cursor=\(nextCursor)&count=200", headers: ["authorization": authToken])
        return res.flatMap { res in
            guard self.statusIsOK(res.http.status.code) else {
                throw Abort(res.http.status, reason: res.http.status.reasonPhrase)
            }
            return try res.content.decode(UserCursor.self, using: self.jsonDecoder)
        }
    }
    
    private func _followersFetcher(of screenName : String, nextCursor : Int64 = -1, users: Set<User> = []) throws -> Future<UserCursor> {
        return try _followers(of: screenName, nextCursor: nextCursor).flatMap { userCursor in
            let newUsers = users.union(userCursor.users)
            if userCursor.nextCursor > 0 {
                return try self._followersFetcher(of: screenName, nextCursor: userCursor.nextCursor, users: newUsers).map {$0}
            }
            return self.eventLoop.future(UserCursor(users: newUsers))
        }
    }
    
    func fetchFollwers(of screenName : String) throws -> Future<Set<User>> {
        return try _followersFetcher(of: screenName).map{$0.users}
    }
}
