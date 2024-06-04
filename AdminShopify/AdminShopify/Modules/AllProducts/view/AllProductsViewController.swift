//
//  AllProductsViewController.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

import UIKit

class AllProductsViewController: UIViewController {

    @IBOutlet weak var ProductSearch: UISearchBar!
    
    @IBOutlet weak var productTableView: UITableView!
    
    @IBOutlet weak var addProductBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: "AllProductsTableViewCell", bundle: nil)
        productTableView.register(cell, forCellReuseIdentifier: "allProductCell")
        productTableView.backgroundColor = UIColor.systemGray6
    }

}

extension AllProductsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allProductCell", for: indexPath) as! AllProductsTableViewCell
        cell.productItemImg.image = UIImage(named: "unnamed")
        cell.productItemDescription.text = "the shirt are one of most high brand all over the world"
        cell.productItemCountInStore.text = "19"+"In store"
        cell.productItemPrice.text = "200$"
        
        return cell
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
