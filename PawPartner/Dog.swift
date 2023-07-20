//
//  Dog.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation
import UIKit

class Dog:Codable {
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
    
    func encodeToJson() -> String{
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                return jsonString
            }
        } catch {
            print("Encoding error: \(error)")
        }
        return "Nun"
    }
        
    static func decodeFromJson(jsonString: String) -> Dog?{
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let decodedDog = try decoder.decode(Dog.self, from: jsonData)
                print(decodedDog)
                return decodedDog
            } catch {
                print("Decoding error: \(error)")
            }
        }
        return nil
    }
    
}
