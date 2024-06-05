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
    var arrProductImg = [UIImage(named: "addidus") , UIImage(named: "unnamed") , UIImage(named: "lock") ,UIImage(named: "addidus") ,UIImage(named: "unnamed") ]
    var timer : Timer?
    var currentCellIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        pageController.numberOfPages = arrProductImg.count
        startTimer()
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
