//
//  NotificationsViewController.swift
//  PawPartner
//
//  Created by Student11 on 11/07/2023.
//

import UIKit

class NotificationsViewController: UIViewController,CustomAlertDelegate {
    
    
    
    @IBOutlet weak var notificationCollectionView: UICollectionView!
    var images: [String] = []
    var dates: [String] = []
    var names: [String] = []
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackgroungHelper.assignBackground(to: view, imagePath: "mydogs_background")
        notificationCollectionView.dataSource = self
        notificationCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dates = []
        names = []
        images = []
        if let readedJson = UserDefaultsManager.shared.getUser(){
            if let readedUser = User.decodeFromJson(jsonString: readedJson){
                self.user = readedUser
                for dog in readedUser.dogs{
                    for n in dog.notifications{
                        self.names.append(dog.name)
                        self.images.append(n.type)
                        self.dates.append(DogNotification.formatDateWithLastTwoDigitsYear(n.date))
                    }
                }
            }
        }
        notificationCollectionView.reloadData()
    }
    @IBAction func onNewNotificationClicked(_ sender: Any) {
        let customAlert = self.storyboard?.instantiateViewController(identifier: "CustomAlertViewController") as! CustomAlertViewController
        customAlert.delegate = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalTransitionStyle = .crossDissolve
        self.present(customAlert, animated: true, completion: nil)
    }
    
    func onSaveClicked(type: String, date: Date, dogId: String) {
        let dogNotification = DogNotification(type: type, date: date)
        DatabaseManager().addNotification(notification: dogNotification, dogId: dogId) {seccsess, error in
            if seccsess{
                //update the user
                for (index, dog) in self.user!.dogs.enumerated(){
                    if dog.id == dogId{
                        self.user?.dogs[index].notifications.append(dogNotification)
                        //Update Collection
                        self.names.append(dog.name)
                        self.images.append(dogNotification.type)
                        self.dates.append(DogNotification.formatDateWithLastTwoDigitsYear(dogNotification.date))
                        self.notificationCollectionView.reloadData()
                    }
                }
                //Save user to UserDefault
                UserDefaultsManager().saveUser(self.user!.encodeToJson())
                
            }else{
                
            }
        }
    }
    
}

    extension NotificationsViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return images.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NotificationsCollectionViewCell
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 20
            cell.titel.text = images[indexPath.row]
            cell.date.text = dates[indexPath.row]
            cell.dogName.text = names[indexPath.row]
            cell.image.image = UIImage(named: images[indexPath.row])
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let item = images[indexPath.row]
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (notificationCollectionView.frame.size.width)
            //let height = (notificationCollectionView.frame.size.height) / 10
            return CGSize(width: width, height: 90)
        }
        
    }

