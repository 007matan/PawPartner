//
//  SignUpViewController.swift
//  PawPartner
//
//  Created by Student11 on 16/07/2023.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    var myFlag: Bool = true
    var progressTimer: Timer?
    var isReversed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
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
    
    @IBAction func onClickedSignUp(_ sender: UIButton) {
        let email_input = email.text ?? "null"
        let name_input = name.text ?? "null"
        let password_input = password.text ?? "null"
        let confirm_input = confirmPassword.text ?? "null"
        if(email_input == "null" || name_input == "null" || password_input == "null" || confirm_input == "null" ) {
            AlertHelper.showAlert(on: self, title: "Error", message: "Missing information, Please try again")
            return
        }else{
            if(isValidEmail(email: email_input) && password_input == confirm_input){
                DispatchQueue.main.async {
                    self.initProgressBar()
                }
                AuthManager().signUp(name: name_input, email: email_input, password: password_input) { result in
                    switch result {
                    case .success(let user):
                        DatabaseManager().addUser(user: user){ success, error in
                            if success {
                                self.myFlag = false
                                AlertHelper.showAlert(on: self, title: "Congratulation!", message: "Youre account created successfully"){
                                    self.dismiss(animated: true, completion: nil)
                                }
                            } else {
                                self.myFlag = false
                                print("Failed to add user to the database: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    case .failure(let error):
                        self.myFlag = false
                        AlertHelper.showAlert(on: self, title: "Error", message: "Somthing went wrong, Please try again")
                        print("Sign-up error: \(error.localizedDescription)")
                    }
                    
                }
            }else{
                AlertHelper.showAlert(on: self, title: "Error", message: "Invalid email or Password, Please try again")
                
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

