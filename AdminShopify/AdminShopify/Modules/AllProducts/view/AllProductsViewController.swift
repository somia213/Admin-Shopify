//
//  AllProductsViewController.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

import UIKit
import Kingfisher

class AllProductsViewController: UIViewController {

    @IBOutlet weak var ProductSearch: UISearchBar!
    
    @IBOutlet weak var productTableView: UITableView!
    
    var productsViewModel: ProductsViewModel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let networkManager = NetworkManager()
                productsViewModel = ProductsViewModel(networkManager: networkManager)
                productsViewModel.getAllProducts { [weak self] success in
                    if success {
                        self?.productTableView.reloadData()
                    } else {
                        print("Error!!!!")
                    }
                }
               let cell = UINib(nibName: "AllProductsTableViewCell", bundle: nil)
               productTableView.register(cell, forCellReuseIdentifier: "allProductCell")
               productTableView.backgroundColor = UIColor.systemGray6
        
                ProductSearch.delegate = self
    }
    
    
    @IBAction func addnewProduct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVarient = storyboard.instantiateViewController(withIdentifier: "AddNewProductViewController") as! AddNewProductViewController
        
                 newVarient.modalPresentationStyle = .fullScreen

                self.present(newVarient, animated: true, completion: nil)
    }
    
}

extension AllProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsViewModel.filteredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allProductCell", for: indexPath) as! AllProductsTableViewCell
        
        let product = productsViewModel.filteredProducts[indexPath.row]
        
        cell.productItemDescription.text = product.title
        cell.productItemCountInStore.text = "\(product.variants.first?.inventory_quantity ?? 0) In store"
        cell.productItemPrice.text = "\(product.variants.first?.price ?? "")"
        
        if let imageUrlString = product.images.first?.src, let imageUrl = URL(string: imageUrlString) {
            cell.productItemImg.kf.setImage(with: imageUrl)
        }else{
            cell.productItemImg.image = UIImage(named: "png-clipart-gray-icons-lock-2")
        }
        
        return cell
    }
}


extension AllProductsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        productsViewModel.filterProducts(searchText: searchText)
        productTableView.reloadData()
    }
}

extension AllProductsViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
