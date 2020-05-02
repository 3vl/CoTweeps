//
//  TwitterClient.swift
//  App
//
//  Created by Victor Lewis on 5/2/20.
//

import Vapor

class TwitterClient : Service {
    private let apiKey = "Bearer "
    var httpClient : Client
    
    let jsonDecoder : JSONDecoder
    
    init(_ container : Container) throws {
        jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        self.httpClient = try container.make(Client.self)
    }
    
    func followersOf(_ screenName : String) throws -> Future<UserCursor> {
        let res = httpClient.get("https://api.twitter.com/1.1/followers/list.json?screen_name=\(screenName)", headers: ["authorization": apiKey])
        return res.flatMap { res in
            return try res.content.decode(UserCursor.self, using: self.jsonDecoder)
        }
    }
}
