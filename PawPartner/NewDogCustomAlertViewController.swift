//
//  NewDogCustomAlertViewController.swift
//  PawPartner
//
//  Created by Student10 on 14/07/2023.
//
import Photos
import PhotosUI
import UIKit

protocol NewDogAlertDelegate{
    func onSaveClicked(name:String, image: UIImage)
}
class NewDogCustomAlertViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageAddButton: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    var delegate:NewDogAlertDelegate? = nil
    var dogImage = UIImage(named: "ic_plus")
    var isValidImage: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        isValidImage = false
    }
    
    
    @IBAction func onImageClicked(_ sender: Any) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            
            results.forEach { result in
                result.itemProvider.loadObject(ofClass: UIImage.self) { [self] reading, error in
                    guard let image = reading as? UIImage, error == nil else{
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                    dogImage = image
                    isValidImage = true
                }
            }
        }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        print("cancel")
    }
    @IBAction func onSaveClicked(_ sender: Any) {
        let name = nameTextField.text ?? ""
        if(name != "" && !name.isEmpty && self.isValidImage!){
            AlertHelper.showAlertWithCancelButton(on: self, title: "Register new Dog", message: "Are you sure you want to add \(name) as youre new Paw Partner?"){
                self.delegate?.onSaveClicked(name: name, image: self.dogImage!)
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            if !self.isValidImage!{
                AlertHelper.showAlert(on: self, title: "Error", message: "Please choose an image for your dog!")
            }else{
                AlertHelper.showAlert(on: self, title: "Error", message: "Please choose a name for your dog!")
                
            }
        }
        
    }
}
