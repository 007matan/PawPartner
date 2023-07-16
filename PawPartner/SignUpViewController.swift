//
//  SignUpViewController.swift
//  PawPartner
//
//  Created by Student11 on 16/07/2023.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onClickedSignUp(_ sender: UIButton) {
        let email_input = email.text ?? "null"
        let name_input = name.text ?? "null"
        let password_input = password.text ?? "null"
        let confirm_input = confirmPassword.text ?? "null"
        if(email_input == "null" || name_input == "null" || password_input == "null" || confirm_input == "null" ) {
            return
        }else{
            if(isValidEmail(email: email_input) && password_input == confirm_input){
                AuthManager().signUp(name: name_input, email: email_input, password: password_input) { result in
                    switch result {
                    case .success(let user):
                        DatabaseManager().addUser(user: user){ success, error in
                            if success {
                                print("User added to the database successfully")
                                self.dismiss(animated: true, completion: nil)
                            } else {
                                print("Failed to add user to the database: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                        
                        print("User signed up:")
                        print("ID: \(user.id)")
                        print("Name: \(user.name)")
                        print("Email: \(user.email)")
                    case .failure(let error):
                        print("Sign-up error: \(error.localizedDescription)")
                    }
                    
                }
            }
        }
            
        }
        
        @IBAction func onClickedBack(_ sender: UIButton) {
            self.dismiss(animated: true, completion: nil)
        }
        
        func isValidEmail(email: String) -> Bool {
            let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
        
    }

