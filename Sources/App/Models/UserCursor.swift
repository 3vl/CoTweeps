//
//  UserCursor.swift
//  App
//
//  Created by Victor Lewis on 4/29/20.
//

import Vapor

final class UserCursor {
    var next_cursor : Int64
    var previous_cursor: Int64
    var users : [User] 
    
    init(next_cursor : Int64, previous_cursor : Int64, users : [User]) {
        self.next_cursor = next_cursor
        self.previous_cursor = previous_cursor
        self.users = users
    }
}

extension UserCursor : Content { }
