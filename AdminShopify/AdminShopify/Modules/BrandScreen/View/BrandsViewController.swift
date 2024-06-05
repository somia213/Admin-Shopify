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
            return CGSize(width: (collectionView.bounds.width*0.45), height: (collectionView.bounds.width*0.65))
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1, left: 10, bottom: 1, right: 10)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with the name of
                let availableProduct = storyboard.instantiateViewController(withIdentifier: "AvaliableProductViewController") as! AvaliableProductViewController
        
                availableProduct.modalPresentationStyle = .fullScreen

                self.present(availableProduct, animated: true, completion: nil)
        
    }

}
