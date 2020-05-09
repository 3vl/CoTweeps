//
//  CoTweepsController.swift
//  App
//
//  Created by Victor Lewis on 4/28/20.
//
import Vapor

struct FollowersView : Encodable {
    let screenName : String
    let users : Set<User>
    
    init(_ screenName : String, _ users : Set<User>) {
        self.screenName = screenName
        self.users = users
    }
}

final class CoTweepsController {
    func followersOf(_ req : Request) throws -> Future<FollowersView> {
        let logger = try req.make(Logger.self)
        let screenName = try req.parameters.next(String.self)

        logger.debug("Request for followers of \(screenName)")
        
        let twitter = try req.make(TwitterClient.self)
        do {
            return try twitter.fetchFollwers(of: screenName).map {users in
                return FollowersView(screenName, users)
            }
        } catch {
            print("Unexpected error: \(error).")
            throw error;
        }
    }
}
