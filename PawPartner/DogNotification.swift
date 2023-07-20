//
//  DogNotification.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//

import Foundation

class DogNotification: Codable{
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
        
    static func decodeFromJson(jsonString: String) -> DogNotification? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let decoder = JSONDecoder()
                let decodedNotification = try decoder.decode(DogNotification.self, from: jsonData)
                print(decodedNotification)
                return decodedNotification
            } catch {
                print("Decoding error: \(error)")
            }
        }
        return nil
    }
}
