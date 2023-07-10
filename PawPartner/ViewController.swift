//
//  ViewController.swift
//  PawPartner
//
//  Created by Student11 on 09/07/2023.
//

import UIKit

class ViewController: UIViewController {

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images: [String] = ["barber", "bowl_empty", "bowl_full", "walk_empty", "walk_full"]
    var names: [String] = ["barber", "bowl_empty", "bowl_full", "walk_empty", "walk_full"]
    var dates: [String] = ["barber", "bowl_empty", "bowl_full", "walk_empty", "walk_full"]
    @IBOutlet weak var petName: UILabel!
    @IBOutlet weak var petImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        petImage.backgroundColor = .blue
        petImage.layer.masksToBounds = true
        petImage.layer.cornerRadius = petImage.frame.height / 2
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }


}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.typeLabel.text = names[indexPath.row]//"cell" - the name of cell attribute
        cell.imageView.image = UIImage(named: images[indexPath.row])
        cell.dateLabel.text = dates[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width - 10) / 2
        return CGSize(width: size, height: size)
    }
    
    
}
