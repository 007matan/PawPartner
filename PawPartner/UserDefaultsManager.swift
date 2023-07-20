//
//  UserDefaultsManager.swift
//  PawPartner
//
//  Created by Student11 on 20/07/2023.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard

    // Define keys for your data points
    private let keyUser = "User"
    // ... add other keys as needed

    // Example method to save username to UserDefaults
    func saveUser(_ userJson: String) {
        userDefaults.set(userJson, forKey: keyUser)
    }

    // Example method to retrieve username from UserDefaults
    func getUser() -> String? {
        return userDefaults.string(forKey: keyUser)
    }
}
