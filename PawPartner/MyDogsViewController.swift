//
//  MyDogsViewController.swift
//  PawPartner
//
//  Created by Student10 on 14/07/2023.
//


import UIKit
import Kingfisher

class MyDogsViewController: UIViewController {

    @IBOutlet weak var myDogsCollectionView: UICollectionView!
    var names: [String] = []
    var images: [String] = []
    var ids: [String] = []
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "mydogs_background")!)
        BackgroungHelper.assignBackground(to: view, imagePath: "mydogs_background")
        
        if let readedJson = UserDefaultsManager.shared.getUser(){
            if let readedUser = User.decodeFromJson(jsonString: readedJson){
                self.user = readedUser
                for dog in readedUser.dogs{
                    self.names.append(dog.name)
                    self.images.append(dog.image)
                    self.ids.append(dog.id)
                }
            }
        }
        
        
        myDogsCollectionView.dataSource = self
        myDogsCollectionView.delegate = self
    }
    
    
    
    
    
    
    
    @IBAction func onNewDogClicked(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(identifier: "NewDogCustomAlertViewController") as! NewDogCustomAlertViewController
        customAlert.delegate = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.modalTransitionStyle = .crossDissolve
        self.present(customAlert, animated: true, completion: nil)
    }
    
    @IBAction func onAddDogClicked(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(identifier: "ExistingDogCustomAlertViewController") as! ExistingDogCustomAlertViewController
        customAlert.delegate = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.modalTransitionStyle = .crossDissolve
        self.present(customAlert, animated: true, completion: nil)
        
    }
    
}

extension MyDogsViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyDogsCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 20
        cell.name.text = names[indexPath.row]
        let url = URL(string: images[indexPath.row])
        cell.image.kf.setImage(with: url)
        let processor = DownsamplingImageProcessor(size: cell.image.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .fade(duration: 0.25)
            .set(to: cell.image)
        cell.copyButton.addTarget(self, action: #selector(copyText(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func copyText(_ sender: UIButton){
        guard let cell = sender.findSuperview(ofType: UICollectionViewCell.self) as? MyDogsCollectionViewCell else{
            return
        }
        guard let indexPath = myDogsCollectionView.indexPath(for: cell) else{
            return
        }
        let text = ids[indexPath.row]
        UIPasteboard.general.string = text
        let name = names[indexPath.row]
        let alert = UIAlertController(title: "Copied", message: "\(name) ID copied to clipboard\nSend \(name) ID to your relative for him to be abled to add \(name) to his dog collection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (myDogsCollectionView.frame.size.width)
        let height = (myDogsCollectionView.frame.size.height) / 10
        return CGSize(width: width, height: height)
    }
    
    
}
                        
extension UIView{
    func findSuperview<T>(ofType type: T.Type) -> T? {
        if let superview = superview{
            if let typedSuperview = superview as? T{
                return typedSuperview
            }else{
                return superview.findSuperview(ofType: type)
            }
        }
        return nil
    }
}

extension MyDogsViewController: NewDogAlertDelegate{
    func onSaveClicked(name: String, image: UIImage) {
        let dog = Dog(image: "", name: name, notifications: [])
        DatabaseManager().addNewDog(dog: dog, image: image){seccsess, error in
            if seccsess{
                DatabaseManager().getDog(id: dog.id){ dog in
                    if let dog = dog {
                        self.user?.dogs.append(dog)
                        self.ids.append(dog.id)
                        self.names.append(dog.name)
                        self.images.append(dog.image)
                        self.myDogsCollectionView.reloadData()
                        UserDefaultsManager().saveUser(self.user!.encodeToJson())
                        
                    } else {
                        AlertHelper.showAlert(on: self, title: "Error", message: "Something went wrong, please try again!")
                    }
                }
            }else{
                AlertHelper.showAlert(on: self, title: "Error", message: "Something went wrong, please try again!")
            }
        }
    }
}
extension MyDogsViewController: ExistingDogAlertDelegate{
    func onSaveClicked(id: String) {
        var idsList = self.ids
        idsList.append(id)
        DatabaseManager().addExistingDog(id: idsList){seccsess, error in
            if seccsess{
                //update the user
                DatabaseManager().getDog(id: id){ dog in
                    if let dog = dog {
                        self.user?.dogs.append(dog)
                        self.ids.append(dog.id)
                        self.names.append(dog.name)
                        self.images.append(dog.image)
                        self.myDogsCollectionView.reloadData()
                        //save to user default
                        UserDefaultsManager().saveUser(self.user!.encodeToJson())
                    } else {
                        AlertHelper.showAlert(on: self, title: "Error", message: "Something went wrong, please try again!")
                    }
                }
            }else{
                AlertHelper.showAlert(on: self, title: "Error", message: "We couldn't find any dog with the given ID!")
            }
        }
    }
}

@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
    
}
