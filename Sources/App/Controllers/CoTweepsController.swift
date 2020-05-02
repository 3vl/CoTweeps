//
//  CoTweepsController.swift
//  App
//
//  Created by Victor Lewis on 4/28/20.
//
import Vapor

struct FollowersView : Encodable {
    let screenName : String
    let userCursor : UserCursor
    
    init(_ screenName : String, _ users : UserCursor) {
        self.screenName = screenName
        self.userCursor = users
    }
}

final class CoTweepsController {
    func followersOf(_ req : Request) throws -> Future<FollowersView> {
        let twitter = try req.make(TwitterClient.self)
        let screenName = try req.parameters.next(String.self)
        return try twitter.followersOf(screenName).map {userCursor in
                FollowersView(screenName, userCursor)
        }
    }
}
