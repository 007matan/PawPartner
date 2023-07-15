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
    
    init(image: String, name: String, notifications: [DogNotification]) {
        self.id = UUID()
        self.image = image
        self.name = name
        self.notifications = notifications
    }
}
