//
//  UserCursor.swift
//  App
//
//  Created by Victor Lewis on 4/29/20.
//

import Vapor

final class TwitterCursor <T : Hashable & Content>  {
    var nextCursor : Int64
    var previousCursor: Int64
    var users : Set<T>
    
    init(nextCursor : Int64 = -1, previousCursor : Int64 = -1, users : Set<T>) {
        self.nextCursor = nextCursor
        self.previousCursor = previousCursor
        self.users = users
    }
}

extension TwitterCursor : Content { }
