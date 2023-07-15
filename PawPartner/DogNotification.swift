//
//  DogNotification.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation

class DogNotification{
    var id: UUID
    var type: String
    var date: Date
    
    init(type: String, date: Date) {
        self.id = UUID()
        self.type = type
        self.date = date
    }
}
