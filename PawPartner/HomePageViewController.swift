//
//  ViewController.swift
//  PawPartner
//
//  Created by Student11 on 09/07/2023.
//

import UIKit
import Kingfisher

class HomePageViewController: UIViewController {

    @IBOutlet weak var supperLabel: UILabel!
    @IBOutlet weak var breakfastLabel: UILabel!
    @IBOutlet weak var eveningLabel: UILabel!
    @IBOutlet weak var afternoonLabel: UILabel!
    @IBOutlet weak var morningLabel: UILabel!
    @IBOutlet weak var dogPicker: UIButton!
    @IBOutlet weak var morningWalk: UIButton!
    @IBOutlet weak var eveningWalk: UIButton!
    @IBOutlet weak var afternoonWalk: UIButton!
    @IBOutlet weak var supper: UIButton!
    @IBOutlet weak var breakfast: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var petImage: UIImageView!
    var user: User?
    var currentDog: Dog?
    var currentDogId = ""
    var walkings: [UIButton] = []
    var meals: [UIButton] = []
    var notificationList: [String] = []
    var notificationDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        BackgroungHelper.assignBackground(to: view, imagePath: "mydogs_background")
        //setDogsPickerMenu()
        walkings = [morningWalk, afternoonWalk, eveningWalk]
        meals = [breakfast, supper]
        petImage.backgroundColor = .blue
        petImage.layer.masksToBounds = true
        petImage.layer.cornerRadius = petImage.frame.height / 2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let readedJson = UserDefaultsManager.shared.getUser(){
            if let readedUser = User.decodeFromJson(jsonString: readedJson){
                user = readedUser
            }
        }
        setDogsPickerMenu()
        if !user!.dogs.isEmpty{
            test(flag: false)
            updateUI(dog: user!.dogs[0])
            self.currentDog = user?.dogs[0]
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.reloadData()
        }else{
            // diable wlking and meals buttons
            test(flag: true)
            AlertHelper.showAlertWithCancelButton(on: self, title: "Congratulation!", message: "Thank you for Choosing Paw Partner!\nWould you like to add youre Paw Partner now?"){
                // goto MyDogsViewController page -> future feature
            }
        }
    }
    
    func test(flag: Bool){
        for i in walkings{
            i.isHidden = flag
        }
        for i in meals{
            i.isHidden = flag
        }
        self.breakfastLabel.isHidden = flag
        self.eveningLabel.isHidden = flag
        self.supperLabel.isHidden = flag
        self.morningLabel.isHidden = flag
        self.afternoonLabel.isHidden = flag
        
    }
    
    func setDogsPickerMenu(){
        var children: [UIAction] = []
        for dog in user!.dogs{
            let action = UIAction(title: dog.name, handler: { _ in
                self.updateUI(dog: dog)
                self.currentDog = dog
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
        AlertHelper.showAlertWithCancelButton(on: self, title: "Alert", message: "Would you like to update \(self.currentDog!.name) morning walk status?"){
            self.updateWalking(WalkingIndex: 0)
        }
        
        
    }
    @IBAction func onAfternoonWalkClicked(_ sender: Any) {
        AlertHelper.showAlertWithCancelButton(on: self, title: "Alert", message: "Would you like to update \(self.currentDog!.name) afternoon walk status?"){
            self.updateWalking(WalkingIndex: 1)
        }
    }
    @IBAction func onEveningWalkClicked(_ sender: Any) {
        AlertHelper.showAlertWithCancelButton(on: self, title: "Alert", message: "Would you like to update \(self.currentDog!.name) evening walk status?"){
            self.updateWalking(WalkingIndex: 2)
        }
        
    }
    @IBAction func onBreakfastClicked(_ sender: Any) {
        AlertHelper.showAlertWithCancelButton(on: self, title: "Alert", message: "Would you like to update \(self.currentDog!.name) breakfast status?"){
            self.updateMeal(mealIndex: 0)
        }
        
    }
    @IBAction func onSupperClicked(_ sender: Any) {
        AlertHelper.showAlertWithCancelButton(on: self, title: "Alert", message: "Would you like to update \(self.currentDog!.name) supper status?"){
            self.updateMeal(mealIndex: 1)
        }
    }
    
    func updateMeal(mealIndex: Int){
        guard let cDog = self.currentDog else{
            print("choose dog first")
            return
        }
        let path = "\(cDog.id)/meal/\(mealIndex)"
                var flag = true
                var image = "meal_full"
                if(cDog.meal[mealIndex]){
                    flag = false
                    image = "meal_empty"
                }
                DatabaseManager().updateWalkingOrMealStatus(path: path, flag: flag){ success, error in
                    if success{
                        for (index, dog) in self.user!.dogs.enumerated(){
                            if dog.id == cDog.id{
                                self.user!.dogs[index].meal[mealIndex] = flag
                                UserDefaultsManager().saveUser(self.user!.encodeToJson())
                            }
                        }
                        self.meals[mealIndex].setImage(UIImage(named: image), for: .normal)
                        print("seccsess")
                    }else{
                        AlertHelper.showAlert(on: self, title: "Error", message: "Something went wrong, Please try again!")
                    }
                }
    }
    
    func updateWalking(WalkingIndex: Int){
        guard let cDog = self.currentDog else{
            print("choose dog first")
            return
        }
        let path = "\(cDog.id)/walking/\(WalkingIndex)"
                var flag = true
                var image = "walk_full"
                if(cDog.walking[WalkingIndex]){
                    flag = false
                    image = "walk_empty"
                }
                DatabaseManager().updateWalkingOrMealStatus(path: path, flag: flag){ success, error in
                    if success{
                        for (index, dog) in self.user!.dogs.enumerated(){
                            if dog.id == cDog.id{
                                self.user!.dogs[index].walking[WalkingIndex] = flag
                                UserDefaultsManager().saveUser(self.user!.encodeToJson())
                            }
                        }
                        self.walkings[WalkingIndex].setImage(UIImage(named: image), for: .normal)
                        print("seccsess")
                    }else{
                        AlertHelper.showAlert(on: self, title: "Error", message: "Something went wrong, Please try again!")
                    }
                }
    }
 
}

extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notificationList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomePageCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = cell.frame.width / 3
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
