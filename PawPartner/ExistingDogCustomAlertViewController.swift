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
            delegate?.onSaveClicked(id: id)
            self.dismiss(animated: true, completion: nil)        }
        
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
        
    }
}
