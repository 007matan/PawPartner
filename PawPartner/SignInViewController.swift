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
    var progressTimer: Timer?
    var isReversed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    func initProgressBar() {
            self.progressBar.isHidden = false
            self.progressBar.setProgress(0, animated: false)
            self.progressBar.progressTintColor = .blue
            
            var progress: Float = 0.0
            let progressIncrement: Float = 0.01

            progressTimer?.invalidate() // Invalidate the previous timer, if any.
            progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if self.isReversed {
                    progress -= progressIncrement
                    if progress <= 0 {
                        progress = 0
                        self.isReversed = false // Change direction to increment.
                    }
                } else {
                    progress += progressIncrement
                    if progress >= 1 {
                        progress = 1
                        self.isReversed = true // Change direction to decrement.
                    }
                }

                DispatchQueue.main.async {
                    self.progressBar.setProgress(progress, animated: true)
                }
                if !self.myFlag {
                    // Invalidate the timer when the flag is false to stop updating the progress bar.
                    timer.invalidate()
                    DispatchQueue.main.async {
                        self.progressBar.isHidden = true
                    }
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
                        DispatchQueue.main.async {
                            self.initProgressBar()
                        }
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
