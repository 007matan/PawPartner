//
//  CustomAlertViewController.swift
//  PawPartner
//
//  Created by Student10 on 13/07/2023.
//

import UIKit

protocol CustomAlertDelegate{
    func onSaveClicked(type:String, date:Date, dogId: String)

}

class CustomAlertViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var notificationPicker: UIButton!
    @IBOutlet weak var dogPicker: UIButton!
    var selectedType:String = ""
    var selectedDog:String = ""
    var dogs: [Dog] = []
    var delegate:CustomAlertDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        if let readedJson = UserDefaultsManager.shared.getUser(){
            if let readedUser2 = User.decodeFromJson(jsonString: readedJson){
                dogs = readedUser2.dogs
            }
        }
        setNitificationPickerMenu()
        setDogsPickerMenu()
        
    }
    
    func setDogsPickerMenu(){
        var children: [UIAction] = []
        
        for dog in dogs{
            let action = UIAction(title: dog.name, handler: { _ in
                self.selectedDog = dog.id
                self.dogPicker.setTitle(dog.name, for: .normal)
            })
            children.append(action)
        }
        dogPicker.menu = UIMenu(title:"Pick Dog", options: .displayInline, children: children)
    }
    
    
    
    
    
    
    
    func setNitificationPickerMenu(){

        notificationPicker.menu = UIMenu(title:"Pick notification type",options: .displayInline, children: [
            UIAction(title: "Barber", image: UIImage(named: "Barber"), handler: {(_) in
                print("test1")
                self.selectedType = "Barber"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
            }),
            UIAction(title: "Bath", image: UIImage(named: "Bath"), handler: {(_) in
                print("test2")
                self.selectedType = "Bath"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
            }),
            UIAction(title: "Contest", image: UIImage(named: "Contest"), handler: {(_) in
                print("test3")
                self.selectedType = "Contest"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
            }),
            UIAction(title: "Dental care", image: UIImage(named: "Dental care"), handler: {(_) in
                print("test4")
                self.selectedType = "Dental care"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
                
            }),
            UIAction(title: "Flea care", image: UIImage(named: "Flea care"), handler: {(_) in
                print("test5")
                self.selectedType = "Flea care"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
            }),
            UIAction(title: "Order food", image: UIImage(named: "Order food"), handler: {(_) in
                print("test6")
                self.selectedType = "Order food"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
            }),
            UIAction(title: "Training", image: UIImage(named: "Training"), handler: {(_) in
                print("test7")
                self.selectedType = "Training"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
            }),
            UIAction(title: "Vaccination", image: UIImage(named: "Vaccination"), handler: {(_) in
                print("test8")
                self.selectedType = "Vaccination"
                self.notificationPicker.setTitle(self.selectedType, for: .normal)
            })])
    }
    

    @IBAction func onSaveClicked(_ sender: Any) {
        if(self.selectedType != "" && datePicker.date >= Date() && self.selectedDog != ""){
            delegate?.onSaveClicked(type: self.selectedType, date: datePicker.date, dogId: self.selectedDog)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    
}
