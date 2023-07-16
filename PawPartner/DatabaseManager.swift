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
    
    func getDogNotification(id: String, completion: @escaping (DogNotification?) -> Void) {
        database.child("Notifications").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let notificationData = snapshot.value as? [String: Any],
               let id = notificationData["id"] as? String,
               let type = notificationData["type"] as? String,
               let dateString = notificationData["date"] as? String,
               let date = self.parseDateFromString(dateString) { // Convert dateString to Date
                let dogNotification = DogNotification(id: id, type: type, date: date)
                   completion(dogNotification)
            } else {
                completion(nil) // Notification not found or data structure mismatch
            }
        })
    }

    
    func getDog(id: String, completion: @escaping (Dog?) -> Void) {
        database.child("Dogs").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dogData = snapshot.value as? [String: Any],
               let id = dogData["id"] as? String,
               let image = dogData["image"] as? String,
               let name = dogData["name"] as? String,
               let notifications = dogData["notifications"] as? [String],
               let walking = dogData["walking"] as? [Bool],
               let meal = dogData["meal"] as? [Bool] {
                var notificationList:[DogNotification] = []
                for notification in notifications {
                    self.getDogNotification(id: notification){ notification in
                        if let notification = notification {
                            notificationList.append(notification)
                        } else {
                            print("notification not found!")
                        }
                    }
                    
                }
                
            
                   let dog = Dog(id: id, image: image, name: name, notifications: notificationList, walking: walking, meal: meal)
                   completion(dog)
            } else {
                completion(nil) // Dog not found or data structure mismatch
            }
        })
    }
    
    
    func getUser(id: String, completion: @escaping (User?) -> Void) {
        database.child("Users").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let id = userData["id"] as? String,
               let name = userData["name"] as? String,
               let email = userData["email"] as? String,
               let password = userData["password"] as? String,
               let dogs = userData["dogs"] as? [String] {
                var dogList: [Dog] = []
                let dispatchGroup = DispatchGroup() // Used to wait for all dogs to be fetched
                
                for dog in dogs {
                    dispatchGroup.enter()
                    self.getDog(id: dog) { dog in
                        if let dog = dog {
                            dogList.append(dog)
                        } else {
                            print("Dog does not exist")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    let user = User(id: id, name: name, email: email, password: password, dogs: dogList)
                    completion(user)
                }
            } else {
                completion(nil) // No user data or invalid data
            }
        })
    }

    
    
    
    

    
    
    func getUser2(id:String){
            database.child("Users").child(id).observeSingleEvent(of: .value, with: { snapshot in
                if let userData = snapshot.value as? [String: Any],
                   let id = userData["id"] as? String,
                   let name = userData["name"] as? String,
                   let email = userData["email"] as? String,
                   let password = userData["password"] as? String,
                   let dogs = userData["dogs"] as? [String] {
                    var dogList: [Dog] = []
                    for dog in dogs{
                        self.getDog(id: dog){ dog in
                            if let dog = dog {
                                dogList.append(dog)
                            } else {
                                print("dog not exist")
                            }
                        }
                        
                    }
                    
                
                       let user = User(id: id, name: name, email: email, password: password, dogs: dogList)
                       // Do something with the user object
                       // e.g., pass it to a completion handler, update UI, etc.
                }
            })

        }
    
    func addUser(user: User, completion: @escaping (Bool, Error?) -> Void) {
        // Set the user's data at the user reference path
        database.child("Users").child(user.id).child("name").setValue(user.name) { error, _ in
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
        database.child("Notifications").child(notification.id).setValue(notificationDict) { (error, _) in
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
        let mdatabase = database.child("Dogs").child(id)
            
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
            let dogRef = database.child("Dogs").child(dog.id)
            
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
