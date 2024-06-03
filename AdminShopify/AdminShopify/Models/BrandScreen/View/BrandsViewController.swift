//
//  BrandsViewController.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import UIKit

class BrandsViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brandsCollectionView.dataSource = self
        brandsCollectionView.delegate = self
        brandsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 12
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandsCollectionViewCell
            
            cell.brandImage.image = UIImage(named: "unnamed")
            return cell
        }

}

extension ViewController : UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let paddingSpace = 10 * 3 // 10 points for left, right, and inter-item spacing
            let availableWidth = collectionView.frame.width - CGFloat(paddingSpace)
            let widthPerItem = availableWidth / 2
            return CGSize(width: widthPerItem, height: widthPerItem * 0.85) // Adjust height as needed
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        }
    

}
