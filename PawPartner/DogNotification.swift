//
//  DogNotification.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation

class DogNotification{
    var id: String
    var type: String
    var date: Date
    
    init(id: String, type: String, date: Date) {
        self.id = id
        self.type = type
        self.date = date
    }
    
    init(type: String, date: Date) {
        self.id = UUID().uuidString
        self.type = type
        self.date = date
    }
}
