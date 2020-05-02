//
//  User.swift
//  App
//
//  Created by Victor Lewis on 4/29/20.
//

import Vapor

final class User {
    var id : Int64
    var id_str : String
    var name : String
    var screen_name : String
    
    init(id : Int64, id_str : String, name : String, screen_name : String) {
        self.id = id
        self.id_str = id_str
        self.name = name
        self.screen_name = screen_name
    }
}

extension User : Content { }

