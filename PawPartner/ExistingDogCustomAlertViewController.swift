//
//  ExistingDogCustomAlertViewController.swift
//  PawPartner
//
//  Created by Student10 on 14/07/2023.
//

import UIKit

protocol ExistingDogAlertDelegate{
    func onSaveClicked(id: String)
}

class ExistingDogCustomAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    var delegate:ExistingDogAlertDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func onSaveClicked(_ sender: Any) {
        let id = idTextField.text ?? ""
        if(id != "" && !id.isEmpty){
            AlertHelper.showAlertWithCancelButton(on: self, title: "Add new dog", message: "Are you sure you want to add a new Paw Partner?"){
                self.delegate?.onSaveClicked(id: id)
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            AlertHelper.showAlert(on: self, title: "Error", message: "Please enter dog id!")
            
        }
        
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
        
    }
}
