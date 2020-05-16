//
//  TwitterClient.swift
//  App
//
//  Created by Victor Lewis on 5/16/20.
//

import Vapor

public protocol TwitterClient : Service {
    func fetchFollwers(of screenName : String) throws -> Future<Set<Int64>>
    func lookupUsers(userIds ids : Set<Int64>) throws -> Future<Set<User>>
}
