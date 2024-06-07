//
//  BrandsViewController.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import UIKit
import Kingfisher

class BrandsViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var brandCollectionView: UICollectionView!
    
    var brandViewModel: BrandViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        brandCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        brandViewModel = BrandViewModel()
        brandViewModel = BrandViewModel()
                brandViewModel.dataUpdated = { [weak self] in
                    DispatchQueue.main.async {
                        self?.brandCollectionView.reloadData()
                    }
                }
                brandViewModel.noInternetConnection = { [weak self] in
                    DispatchQueue.main.async {
                        self?.showNoInternetAlert()
                    }
                }
                brandViewModel.fetchData()
            }
    
    func showNoInternetAlert() {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandViewModel.numberOfCollections()
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandsCollectionViewCell
            let brand = brandViewModel.collection(at: indexPath.row)
            
            if let imageUrl = URL(string: brand.image.src) {
                    cell.brandImage.kf.setImage(with: imageUrl)
                }
            
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil) 
                let availableProduct = storyboard.instantiateViewController(withIdentifier: "AvaliableProductViewController") as! AvaliableProductViewController
        
                availableProduct.modalPresentationStyle = .fullScreen

                self.present(availableProduct, animated: true, completion: nil)
        
    }

}
