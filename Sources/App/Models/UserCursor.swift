//
//  UserCursor.swift
//  App
//
//  Created by Victor Lewis on 4/29/20.
//

import Vapor

final class UserCursor  {
    var nextCursor : Int64
    var previousCursor: Int64
    var users : Set<User>
    
    init(nextCursor : Int64 = -1, previousCursor : Int64 = -1, users : Set<User>) {
        self.nextCursor = nextCursor
        self.previousCursor = previousCursor
        self.users = users
    }
}

extension UserCursor : Content { }
