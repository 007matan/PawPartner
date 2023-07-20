//
//  User.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation

class User: Codable{
    var id: String
    var name: String
    var email: String
    var dogs: [Dog]
    
    init(id: String, name: String, email: String, dogs: [Dog]) {
        self.id = id
        self.name = name
        self.email = email
        self.dogs = dogs
    }
    
    func encodeToJson() -> String {
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
        return "NuN"
    }
        
    static func decodeFromJson(jsonString: String) -> User? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let decodedUser = try decoder.decode(User.self, from: jsonData)
                print(decodedUser)
                return decodedUser
            } catch {
                print("Decoding error: \(error)")
            }
        }
        return nil
    }
    
}
