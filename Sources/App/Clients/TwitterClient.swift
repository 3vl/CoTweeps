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
    
    init(_ client : Client, _ logger : Logger) throws {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let apiToken = Environment.get("TWITTER_TOKEN") else {
            throw Abort(.internalServerError)
        }
        authToken =  "Bearer " + apiToken
        
        self.logger = logger
                
        self.httpClient = client
    }
    
    func followersOf(_ screenName : String) throws -> Future<UserCursor> {
        logger.debug("Fetching followers of \(screenName)")
        let res = httpClient.get("https://api.twitter.com/1.1/followers/list.json?screen_name=\(screenName)", headers: ["authorization": authToken])
        return res.flatMap { res in
            return try res.content.decode(UserCursor.self, using: self.jsonDecoder)
        }
    }
}
