//
//  UserCursor.swift
//  App
//
//  Created by Victor Lewis on 4/29/20.
//

import Vapor

final class TwitterCursor {
    var nextCursor : Int64
    var previousCursor: Int64
    var ids : Set<Int64>
    
    init(nextCursor : Int64 = -1, previousCursor : Int64 = -1, ids : Set<Int64>) {
        self.nextCursor = nextCursor
        self.previousCursor = previousCursor
        self.ids = ids
    }
}

extension TwitterCursor : Content { }
