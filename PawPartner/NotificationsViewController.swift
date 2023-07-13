//
//  NotificationsViewController.swift
//  PawPartner
//
//  Created by Student11 on 11/07/2023.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var datePicker: NSLayoutConstraint!
    @IBOutlet weak var dropDown: UIButton!
    @IBOutlet weak var notificationCollectionView: UICollectionView!
    let images: [String] = ["Barber", "Bath", "Contest", "Dental care", "Flea care"]
    let dates: [String] = ["1/1/20", "2/1/20", "1/1/23", "4/1/23", "5/6/23"]
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCollectionView.dataSource = self
        notificationCollectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBAction func onSaveClicked(_ sender: Any) {
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
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
            cell.image.image = UIImage(named: images[indexPath.row])
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let item = images[indexPath.row]
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (notificationCollectionView.frame.size.width)
            let height = (notificationCollectionView.frame.size.height) / 10
            return CGSize(width: width, height: height)
        }
        
    }

