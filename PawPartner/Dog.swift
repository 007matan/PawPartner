//
//  Dog.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation
import UIKit

class Dog {
    var id: UUID
    var image: String
    var name: String
    var notifications: [DogNotification]
    var walking: [Bool]
    var meal: [Bool]
    
    init(image: String, name: String, notifications: [DogNotification]) {
        self.id = UUID()
        self.image = image
        self.name = name
        self.notifications = notifications
        self.walking = [Bool](repeating: false, count: 3)
        self.meal = [Bool](repeating: false, count: 2)
    }
}
