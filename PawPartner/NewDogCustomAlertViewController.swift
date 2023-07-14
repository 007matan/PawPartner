//
//  NewDogCustomAlertViewController.swift
//  PawPartner
//
//  Created by Student10 on 14/07/2023.
//

import UIKit

protocol NewDogAlertDelegate{
    func onSaveClicked(name:String)
}
class NewDogCustomAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    var delegate:NewDogAlertDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func onImageClicked(_ sender: Any) {
        // open galery
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    @IBAction func onSaveClicked(_ sender: Any) {
        let name = nameTextField.text ?? ""
        if(name != "" && !name.isEmpty){
            delegate?.onSaveClicked(name: name)
        }
    }
}
