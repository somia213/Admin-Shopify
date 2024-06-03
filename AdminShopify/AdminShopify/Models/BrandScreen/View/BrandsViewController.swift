//
//  BrandsViewController.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import UIKit

class BrandsViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var brandCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        brandCollectionView.collectionViewLayout = UICollectionViewFlowLayout()

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 12
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandsCollectionViewCell
            
            cell.brandImage.image = UIImage(named: "addidus")
            return cell
        }

}

extension BrandsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: (collectionView.bounds.width*0.45), height: (collectionView.bounds.width*0.85))
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        }

}
