//
//  User.swift
//  App
//
//  Created by Victor Lewis on 4/29/20.
//

import Vapor

final class User {
    var id : Int64
    var name : String
    var screenName : String
    
    init(id : Int64, name : String, screenName : String) {
        self.id = id
        self.name = name
        self.screenName = screenName
    }
}

extension User : Content { }

extension User : Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

