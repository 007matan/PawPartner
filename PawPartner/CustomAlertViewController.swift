//
//  CustomAlertViewController.swift
//  PawPartner
//
//  Created by Student10 on 13/07/2023.
//

import UIKit

protocol CustomAlertDelegate{
    func onSaveClicked(type:String, date:Date)

}

class CustomAlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var notificationPicker: UIButton!
    @IBOutlet weak var datePicker: NSLayoutConstraint!
    var delegate:CustomAlertDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func onSaveClicked(_ sender: Any) {
        delegate?.onSaveClicked(type: "String", date: Date())
        print("saved")
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
}
