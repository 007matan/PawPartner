//
//  SignInViewController.swift
//  PawPartner
//
//  Created by Student11 on 16/07/2023.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickedSignIn(_ sender: UIButton) {
        let email_input = email.text ?? "null"
        let password_input = password.text ?? "null"
        if(email_input == "null" || password_input == "null"){
            print("Missing on or more arguments")
        }else{
            if(isValidEmail(email: email_input)){
                AuthManager().signIn(email: email_input, password: password_input) { result in
                    switch result {
                    case .success(let user):
                        // retrive user data
                        DatabaseManager().getUser(id: user.id){ user in
                            if let user = user {
                               //let jsonString = user.encodeToJson()
                                //print("json: \(jsonString)")
                                print("cc")
                               // let defaultsManager = UserDefaultsManager.shared

                                        // Save data using UserDefaultsManager methods
                               // defaultsManager.saveUser(jsonString)
                               // if let readedJson = defaultsManager.getUser(){
                                    
                                 //   if let readedUser2 = //User.decodeFromJson(jsonString: //readedJson){
                                //        print("Ronius: \(readedUser2)")
                                //    }
                                //}
                                // User object is available
                                // Access other properties and perform actions with the user object
                            } else {
                                // Unable to fetch the user or user does not exist
                                print("Unable to fetch user")
                            }
                        }
                        // goto main page
                        if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewControllerID") as? UITabBarController {
                            tabBarController.modalPresentationStyle = .fullScreen
                            self.present(tabBarController, animated: true, completion: nil)
                        }
                        print("User signed in:")
                        print("ID: \(user.id)")
                        print("Name: \(user.name)")
                        print("Email: \(user.email)")
                    case .failure(let error):
                        print("Sign-in error: \(error.localizedDescription)")
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func onClickedSignUp(_ sender: Any) {
        let destinationVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.present(destinationVC, animated: true, completion: nil)

    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    
    func saveUserToUD(user:User){
        
    }
}
