//
//  ViewController.swift
//  PawPartner
//
//  Created by Student11 on 09/07/2023.
//

import UIKit

class HomePageViewController: UIViewController {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    let images: [String] = ["barber", "bowl_empty", "bowl_full", "walk_empty", "walk_full"]
    let names: [String] = ["barber", "bowl_empty", "bowl_full", "walk_empty", "walk_full"]
    let dates: [String] = ["1/1/20", "2/1/20", "1/1/23", "4/1/23", "5/6/23"]
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        petImage.backgroundColor = .blue
        petImage.layer.masksToBounds = true
        petImage.layer.cornerRadius = petImage.frame.height / 2
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension HomePageViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomePageCollectionViewCell
        cell.typeLabel.text = names[indexPath.row]//"cell" - the name of cell attribute
        cell.imageView.image = UIImage(named: images[indexPath.row])
        cell.dateLabel.text = dates[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = names[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width) / 4
        let height = (collectionView.frame.size.height) / 2
        return CGSize(width: width, height: height)
    }
    
}
