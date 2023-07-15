//
//  MyDogsViewController.swift
//  PawPartner
//
//  Created by Student10 on 14/07/2023.
//

import UIKit

class MyDogsViewController: UIViewController {

    @IBOutlet weak var myDogsCollectionView: UICollectionView!
    let names: [String] = ["Hipper", "Rey", "Bono"]
    let images: [String] = ["Bath", "Training", "Contest"]
    let id: [String] = ["1", "2","3"]
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.name.text = names[indexPath.row]
        cell.image.image = UIImage(named: images[indexPath.row])
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
        let text = id[indexPath.row]
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
        print(name)
        print(image)
    }
}
extension MyDogsViewController: ExistingDogAlertDelegate{
    func onSaveClicked(id: String) {
        print(id)
    }
}
