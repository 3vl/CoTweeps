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
        let screenName = try req.parameters.next(String.self)
        return try twitter.followersOf(screenName)
    }
}
