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
        let twitter = TwitterClient(client: client)
        return try twitter.followersOf("3vl")
    }
}
