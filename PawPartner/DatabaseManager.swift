//
//  FirebaseManager.swift
//  PawPartner
//
//  Created by Student11 on 15/07/2023.
//
import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import UIKit

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    
    func parseDateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Modify the date format according to your actual date string format
        
        return dateFormatter.date(from: dateString)
    }
    
    func addUser(user: User, completion: @escaping (Bool, Error?) -> Void) {
        // Set the user's data at the user reference path
        database.child("Users").child(user.id.uuidString).child("name").setValue(user.name) { error, _ in
            if let error = error {
                completion(false, error)
                print("Failed to add user to the Realtime Database: \(error.localizedDescription)")
            } else {
                completion(true, nil)
                print("User added successfully to the Realtime Database")
            }
        }
    }

    public func addNotification(notification: DogNotification){
        // Convert DogNotification properties to compatible types
        let notificationDict: [String: Any] = [
            "type": notification.type,
            "date": notification.date.timeIntervalSince1970
        ]
        // Write the data to the Firebase database
        database.child("Notifications").child(notification.id.uuidString).setValue(notificationDict) { (error, _) in
            if let error = error {
                // Handle the error
                print("Error writing data to Firebase: \(error)")
            } else {
                // Data was successfully written
                print("Data written to Firebase")
            }
        }
    }
    
    public func addExistingDog(id: String){
        checkDogExists(withID: id) { exist in
            if exist {
                //add dog to user
                self.database.child("Users").child("Dogs").child(id).setValue(id)
            }
            else{
                print("Dog doesn't exist on Firebase")
            }
        }
    }
    
    func checkDogExists(withID id: String, completion: @escaping (Bool) -> Void) {
            var mdatabase = database.child("Dogs").child(id)
            
            mdatabase.observeSingleEvent(of: .value) { (snapshot) in
                completion(snapshot.exists())
            }
        }
    func addNewDog(dog: Dog, image: UIImage) {
        let storageRef = Storage.storage().reference()
            // Convert Dog properties to compatible types
            let dogDict: [String: Any] = [
                "name": dog.name
            ]
            
            // Generate a unique ID for the dog in the Firebase Realtime Database
            let dogRef = database.child("Dogs").child(dog.id.uuidString)
            
            // Upload the image to Firebase Storage
        let imageRef = storageRef.child("dog_images/\(String(describing: dogRef.key)).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        // Handle the error
                        print("Error uploading image to Firebase Storage: \(error)")
                    } else {
                        // Get the download URL for the uploaded image
                        imageRef.downloadURL { (url, error) in
                            if let imageUrl = url?.absoluteString {
                                // Update the dogDict with the image URL
                                var updatedDogDict = dogDict
                                updatedDogDict["image"] = imageUrl
                                
                                // Write the data to the Firebase Realtime Database
                                dogRef.setValue(updatedDogDict) { (error, _) in
                                    if let error = error {
                                        // Handle the error
                                        print("Error adding dog to Firebase: \(error)")
                                    } else {
                                        // Dog was successfully added
                                        print("Dog added to Firebase")
                                    }
                                }
                            } else {
                                // Handle the error
                                print("Error retrieving image URL from Firebase Storage: \(error?.localizedDescription ?? "")")
                            }
                        }
                    }
                }
            }
        }
   
}
