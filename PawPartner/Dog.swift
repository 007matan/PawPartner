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
    var image: UIImage
    var name: String
    var notifications: [DogNotification]
    
    init(image: UIImage, name: String, notifications: [DogNotification]) {
        self.id = UUID()
        self.image = image
        self.name = name
        self.notifications = notifications
    }
}
