//
//  Dog.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation
import UIKit

class Dog {
    var id: String
    var image: String
    var name: String
    var notifications: [DogNotification]
    var walking: [Bool]
    var meal: [Bool]
    
    init(id: String, image: String, name: String, notifications: [DogNotification], walking: [Bool], meal: [Bool]) {
        self.id = id
        self.image = image
        self.name = name
        self.notifications = notifications
        self.walking = walking
        self.meal = meal
    }
    
    
    init(image: String, name: String, notifications: [DogNotification]) {
        self.id = UUID().uuidString
        self.image = image
        self.name = name
        self.notifications = notifications
        self.walking = [Bool](repeating: false, count: 3)
        self.meal = [Bool](repeating: false, count: 2)
    }
}
