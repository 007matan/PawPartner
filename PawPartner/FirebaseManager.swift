//
//  FirebaseManager.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//
import Firebase
import FirebaseDatabase

class FirebaseManager {
    let databaseRef: DatabaseReference
    
    init() {
        FirebaseApp.configure()
        databaseRef = Database.database().reference()
    }
    
    func readData(completion: @escaping (String?) -> Void) {
        databaseRef.observe(.value) { snapshot in
            if let value = snapshot.value as? String {
                completion(value)
            } else {
                completion(nil)
            }
        }
    }
    
    func writeData(data: String) {
        databaseRef.setValue(data)
    }
}
