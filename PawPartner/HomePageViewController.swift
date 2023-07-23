//
//  ViewController.swift
//  PawPartner
//
//  Created by Student11 on 09/07/2023.
//

import UIKit
import Kingfisher

class HomePageViewController: UIViewController {

    @IBOutlet weak var dogPicker: UIButton!
    @IBOutlet weak var morningWalk: UIButton!
    @IBOutlet weak var eveningWalk: UIButton!
    @IBOutlet weak var afternoonWalk: UIButton!
    @IBOutlet weak var supper: UIButton!
    @IBOutlet weak var breakfast: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var petImage: UIImageView!
    var user: User?
    var walkings: [UIButton] = []
    var meals: [UIButton] = []
    var notificationList: [String] = []
    var notificationDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let readedJson = UserDefaultsManager.shared.getUser(){
            if let readedUser = User.decodeFromJson(jsonString: readedJson){
                user = readedUser
            }
        }
        setDogsPickerMenu()
        walkings = [morningWalk, afternoonWalk, eveningWalk]
        meals = [breakfast, supper]
        petImage.backgroundColor = .blue
        petImage.layer.masksToBounds = true
        petImage.layer.cornerRadius = petImage.frame.height / 2
        
    }
    
    func setDogsPickerMenu(){
        var children: [UIAction] = []
        
        for dog in user!.dogs{
            let action = UIAction(title: dog.name, handler: { _ in
                self.updateUI(dog: dog)
                self.collectionView.dataSource = self
                self.collectionView.delegate = self
                self.collectionView.reloadData()
            })
            children.append(action)
        }
        dogPicker.menu = UIMenu(title:"Pick Dog", options: .displayInline, children: children)
    }
    
    func updateUI(dog: Dog){
        
        self.dogPicker.setTitle(dog.name, for: .normal)
        self.notificationList = []
        self.notificationDates = []
        
        
        let url = URL(string: dog.image)
        petImage.kf.setImage(with: url)
        let processor = DownsamplingImageProcessor(size: petImage.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        KF.url(url)
            .setProcessor(processor)
            .loadDiskFileSynchronously()
            .fade(duration: 0.25)
            .set(to: petImage)
        
        for n in dog.notifications{
            self.notificationList.append(n.type)
            self.notificationDates.append(DogNotification.getDateFormat(n.date, format: "dd/MM/yy"))
        }
        var walkingImage = ""
        for (i, flag) in dog.walking.enumerated(){
            if flag == true{
                walkingImage = "walk_full"
            }else{
                walkingImage = "walk_empty"
            }
            self.walkings[i].setImage(UIImage(named: walkingImage), for: .normal)
            
        }
        var mealImage = ""
        for (i, flag) in dog.meal.enumerated(){
            if flag{
                mealImage = "meal_full"
            }else{
                mealImage = "meal_empty"
            }
            self.meals[i].setImage(UIImage(named: mealImage), for: .normal)
        }
    }
    

    
    
    @IBAction func onMorningWalkClicked(_ sender: Any) {
        morningWalk.setImage(UIImage(named: "walk_full"), for: .normal)
    }
    @IBAction func onAfternoonWalkClicked(_ sender: Any) {
        afternoonWalk.setImage(UIImage(named: "walk_full"), for: .normal)
    }
    @IBAction func onEveningWalkClicked(_ sender: Any) {
        eveningWalk.setImage(UIImage(named: "walk_full"), for: .normal)
        
    }
    @IBAction func onBreakfastClicked(_ sender: Any) {
        breakfast.setImage(UIImage(named: "bowl_full"), for: .normal)
        
    }
    @IBAction func onSupperClicked(_ sender: Any) {
        supper.setImage(UIImage(named: "bowl_full"), for: .normal)
        
    }
    
    
    
    
    
    
}

extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notificationList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomePageCollectionViewCell
        cell.typeLabel.text = notificationList[indexPath.row]//"cell" - the name of cell attribute
        cell.imageView.image = UIImage(named: notificationList[indexPath.row])
        cell.dateLabel.text = notificationDates[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width) / 4
        let height = (collectionView.frame.size.height) / 2
        return CGSize(width: width, height: height)
    }
   
}
