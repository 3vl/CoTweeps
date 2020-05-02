//
//  CoTweepsController.swift
//  App
//
//  Created by Victor Lewis on 4/28/20.
//
import Vapor


final class CoTweepsController {
    func followersOf(_ req : Request) throws -> Future<UserCursor> {
        let client = try req.make(Client.self)        
        let res = client.get("https://api.twitter.com/1.1/followers/list.json?screen_name=3vl", headers: ["authorization":"Bearer ])
        return res.flatMap { res in
            return try res.content.decode(UserCursor.self)
        }
    }
}
