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
    
    
    func dateFromUnixTimestampString(_ unixTimestampString: String) -> Date? {
        guard let unixTimestamp = TimeInterval(unixTimestampString) else {
            // Invalid input, return nil
            return nil
        }
        return Date(timeIntervalSince1970: unixTimestamp)
    }
    
    
    func getDogNotification(id: String, completion: @escaping (DogNotification?) -> Void) {
        database.child("Notifications").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let notificationData = snapshot.value as? [String: Any],
               let id = notificationData["id"] as? String,
               let type = notificationData["type"] as? String,
               let dateString = notificationData["date"] as? Int,
               let date = self.dateFromUnixTimestampString(String(dateString)) { // Convert dateString to Date
                let dogNotification = DogNotification(id: id, type: type, date: date)
                   completion(dogNotification)
            } else {
                completion(nil) // Notification not found or data structure mismatch
            }
        })
    }

    
    func getDog(id: String, completion: @escaping (Dog?) -> Void) {
        print("A:\(id)")
        database.child("Dogs").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let dogData = snapshot.value as? [String: Any],
               let id = dogData["id"] as? String,
               let image = dogData["image"] as? String,
               let name = dogData["name"] as? String,
               let notifications = dogData["notifications"] as? [String],
               let walking = dogData["walking"] as? [Bool],
               let meal = dogData["meal"] as? [Bool] {
                var notificationList:[DogNotification] = []
                print("B")
                for notification in notifications {
                    if notification.isEmpty{
                        continue
                    }
                    print("not[i]: \(notification)")
                    self.getDogNotification(id: notification){ notification in
                        if let notification = notification {
                            notificationList.append(notification)
                            print("found not[i] \(notification.id)")
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
        print("1")
        //var dogList: [Dog] = []
        database.child("Users").child(id).observeSingleEvent(of: .value, with: { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let dogs = userData["dogs"] as? [String],
               let email = userData["email"] as? String,
               let id = userData["id"] as? String,
               let name = userData["name"] as? String {
                var dogList: [Dog] = []
                let dispatchGroup = DispatchGroup() // Used to wait for all dogs to be fetched
                print("2")
                for dog in dogs {
                    if dog.isEmpty{
                        continue
                    }
                    print("3: \(dog)")
                    dispatchGroup.enter()
                    self.getDog(id: dog) { dog in
                        if let dog = dog {
                            dogList.append(dog)
                            //print("Dog: -> \(dog)")
                        } else {
                            print("Dog does not exist")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    let user = User(id: id, name: name, email: email, dogs: dogList)
                    completion(user)
                }
            } else {
                completion(nil) // No user data or invalid data
            }
        })
    }

    func addUser(user: User, completion: @escaping (Bool, Error?) -> Void) {
        // Set the user's data at the user reference path
        let userDict:[String:Any] = [
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "dogs": [""]
        ]
        database.child("Users").child(user.id).setValue(userDict) { error, _ in
            if let error = error {
                completion(false, error)
                print("Failed to add user to the Realtime Database: \(error.localizedDescription)")
            } else {
                completion(true, nil)
                print("User added successfully to the Realtime Database")
            }
        }
    }
    
    public func addNotification(notification: DogNotification, dogId: String){
        // Convert DogNotification properties to compatible types
        let notificationDict: [String: Any] = [
            "id": notification.id,
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
                self.database.child("Dogs").child(dogId).child("notifications").observeSingleEvent(of: .value, with: { snapshot in
                    if let list = snapshot.value as? [String]{
                        var notificationList: [String] = []
                        notificationList.append(contentsOf: list)
                        notificationList.append(notification.id)
                        if notificationList[0] == ""{
                            notificationList.remove(at: 0)
                        }
                        self.database.child("Dogs").child(dogId).child("notifications").setValue(notificationList)
                    }
                })
                print("Data written to Firebase")
            }
        }
    }
    
    public func addExistingDog(id: String){
        checkDogExists(withID: id) { exist in
            if exist {
                //add dog to user
                //self.database.child("Users").child("Dogs").child(id).setValue(id)
                self.database.child("Users").child(Auth.auth().currentUser!.uid).child("dogs").child(id).setValue(id)
                
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
                "id": dog.id,
                "name": dog.name,
                "image": dog.image,
                "meal": dog.meal,
                "walking": dog.walking,
                "notifications": [""]
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
                                         //Dog was successfully added
                                        self.database.child("Users").child(Auth.auth().currentUser!.uid).child("dogs").observeSingleEvent(of: .value, with: { snapshot in
                                            if let list = snapshot.value as? [String]{
                                                var dogList: [String] = []
                                                dogList.append(contentsOf: list)
                                                dogList.append(dog.id)
                                                if dogList[0] == ""{
                                                    dogList.remove(at: 0)
                                                }
                                                self.database.child("Users").child(Auth.auth().currentUser!.uid).child("dogs").setValue(dogList)
                                            }
                                        })
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
