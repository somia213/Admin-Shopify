//
//  AvaliableProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 05/06/2024.
//

import UIKit

class AvaliableProductViewController: UIViewController {

    @IBOutlet weak var avaliableProductTableView: UITableView!
    @IBOutlet weak var addProduct: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: "AllProductsTableViewCell", bundle: nil)
        avaliableProductTableView.register(cell, forCellReuseIdentifier: "allProductCell")
        avaliableProductTableView.backgroundColor = UIColor.systemGray6
    }

}

extension AvaliableProductViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
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

extension AvaliableProductViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
