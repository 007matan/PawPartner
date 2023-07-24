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


import UIKit

class AlertHelper {
    
    static func showAlertWithCancelButton(on viewController: UIViewController, title: String, message: String, okAction: (() -> Void)? = nil) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            // Perform the custom action passed in as a closure (if provided)
            okAction?()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        viewController.present(dialogMessage, animated: true, completion: nil)
    }
    
    static func showAlert(on viewController: UIViewController, title: String, message: String, okAction: (() -> Void)? = nil) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            // Perform the custom action passed in as a closure (if provided)
            okAction?()
        })
        
        dialogMessage.addAction(ok)
        viewController.present(dialogMessage, animated: true, completion: nil)
    }

    
}
