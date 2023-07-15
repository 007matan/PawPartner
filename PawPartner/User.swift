//
//  User.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation

class User{
    var id: UUID
    var name: String
    var email: String
    var password: String
    var dogs: [Dog]
    
    init(name: String, email: String, password: String, dogs: [Dog]) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.password = password
        self.dogs = dogs
    }
}
