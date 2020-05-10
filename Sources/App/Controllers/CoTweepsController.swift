//
//  CoTweepsController.swift
//  App
//
//  Created by Victor Lewis on 4/28/20.
//
import Vapor

struct FollowersView : Encodable {
    let screenNames : [String]
    let users : Set<User>
    
    init(_ screenNames : [String], _ users : Set<User>) {
        self.screenNames = screenNames
        self.users = users
    }
}

final class CoTweepsController {
    func followersOf(_ req : Request) throws -> Future<FollowersView> {
        let logger = try req.make(Logger.self)
        let screenName = try req.parameters.next(String.self)
    
        logger.debug("Request for followers of \(screenName)")
        
        let twitter = try req.make(TwitterClient.self)
        var followers = try twitter.fetchFollwers(of: screenName);
        var screenNames = [screenName]
        if let compareFollowers = try? req.query.get(String.self, at: "compareFollowers") {
            screenNames.append(compareFollowers)
            let otherFollowers = try twitter.fetchFollwers(of: compareFollowers)
            followers = followers.and(otherFollowers).map({ (u1 : Set<User>, u2 : Set<User>) -> Set<User> in
                u1.intersection(u2)
            })
        }
        return followers.map {users in
            return FollowersView(screenNames, users)
        }
    }
}
