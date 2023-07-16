//
//  AuthManager.swift
//  PawPartner
//
//  Created by Student10 on 16/07/2023.
//

import FirebaseAuth
import Foundation

class AuthManager{
    
    
    
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    let userData = User(name: user.displayName ?? "", email: user.email ?? "", password: "", dogs: [])
                    completion(.success(userData))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    let unknownError = NSError(domain: "UnknownError", code: 0, userInfo: nil)
                    completion(.failure(unknownError))
                }
            }
        }
    
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let user = authResult?.user {
                    let userData = User(name: name, email: user.email ?? "", password: "", dogs: [])
                    completion(.success(userData))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    let unknownError = NSError(domain: "UnknownError", code: 0, userInfo: nil)
                    completion(.failure(unknownError))
                }
            }
        }
    
    func signOut() {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Error signing out: \(error)")
            }
        }
}
