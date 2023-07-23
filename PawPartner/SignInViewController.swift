//
//  SignInViewController.swift
//  PawPartner
//
//  Created by Student11 on 16/07/2023.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    var myFlag: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    func initProgressBar(){
        self.progressBar.isHidden = false
        self.progressBar.setProgress(0, animated: false)
        self.progressBar.progressTintColor = .blue
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
            print("SEC")
            var progress = 0.0
            var isAnimated = false
            while self.myFlag {
                if(progress > 0.9){
                    progress = 0.0
                    isAnimated = false
                }else{
                    progress = progress + 0.01
                    isAnimated = true
                }
                DispatchQueue.main.async {
                    self.progressBar.setProgress(Float(progress), animated: isAnimated)
                }
                
            }
            DispatchQueue.main.async {
                self.progressBar.isHidden = true
            }
        }
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
                        
                        //self.initProgressBar()
                        DatabaseManager().getUser(id: user.id){ user in
                            if let user = user {
                                let jsonString = user.encodeToJson()
                                let defaultsManager = UserDefaultsManager.shared
                                defaultsManager.saveUser(jsonString)
                                self.myFlag = false
                                if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabViewControllerID") as? UITabBarController {
                                    tabBarController.modalPresentationStyle = .fullScreen
                                    self.present(tabBarController, animated: true,completion: nil)
                                }
                                
                            } else {
                                // Unable to fetch the user or user does not exist
                                print("Unable to fetch user")
                            }
                        }
                        // goto main page
                        
                        
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
