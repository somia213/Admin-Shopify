//
//  EditableProductDetailsViewController.swift
//  AdminShopify
//
//  Created by Somia on 05/06/2024.
//

import UIKit

class EditableProductDetailsViewController: UIViewController {

    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var sizeScrollable: UIScrollView!
    @IBOutlet weak var sizeStackView: UIStackView!
    var arrProductImg = [UIImage(named: "addidus") , UIImage(named: "unnamed") , UIImage(named: "lock") ,UIImage(named: "addidus") ,UIImage(named: "unnamed") ]
    var timer : Timer?
    var currentCellIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        pageController.numberOfPages = arrProductImg.count
        startTimer()
        let sizes = ["Small", "Medium", "Large", "XL", "XXL", "XXXL", "US 6", "US 8", "US 10", "US 12"]
            
            for size in sizes {
                addSize(size: size)
            }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(moveToNextProductImg) , userInfo: nil, repeats: true)
    }
    
   @objc func moveToNextProductImg(){
       if currentCellIndex < arrProductImg.count - 1 {
           currentCellIndex += 1
       }else{
           currentCellIndex = 0
       }
       imgCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
       pageController.currentPage = currentCellIndex
    }
    
    func addSize(size: String) {
        let newSizeView = UIView()
        newSizeView.backgroundColor = UIColor.white
        
        newSizeView.layer.shadowColor = UIColor.gray.cgColor
        newSizeView.layer.shadowOpacity = 0.5
        newSizeView.layer.shadowOffset = CGSize(width: 4, height: 2)
        newSizeView.layer.shadowRadius = 4
        
        let newSizeLabel = UILabel()
        newSizeLabel.text = size
        newSizeLabel.textColor = UIColor.black
        
        newSizeView.addSubview(newSizeLabel)
        
        newSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newSizeLabel.topAnchor.constraint(equalTo: newSizeView.topAnchor, constant: 8),
            newSizeLabel.leadingAnchor.constraint(equalTo: newSizeView.leadingAnchor, constant: 8),
            newSizeLabel.trailingAnchor.constraint(equalTo: newSizeView.trailingAnchor, constant: -8),
            newSizeLabel.bottomAnchor.constraint(equalTo: newSizeView.bottomAnchor, constant: -8)
        ])
        
        sizeStackView.addArrangedSubview(newSizeView)
    }
    
   

}

extension EditableProductDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImg", for: indexPath) as! EditableProductDetailsCollectionViewCell
        
        cell.productImg.image = arrProductImg[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // to size the cell
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
