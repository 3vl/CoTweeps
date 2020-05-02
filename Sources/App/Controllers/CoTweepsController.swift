//
//  CoTweepsController.swift
//  App
//
//  Created by Victor Lewis on 4/28/20.
//
import Vapor

final class CoTweepsController {
    func followersOf(_ req : Request) throws -> Future<UserCursor> {
        let twitter = try req.make(TwitterClient.self)
        return try twitter.followersOf("3vl")
    }
}
