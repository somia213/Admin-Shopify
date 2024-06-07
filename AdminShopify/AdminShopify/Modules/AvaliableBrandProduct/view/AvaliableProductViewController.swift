//
//  AvaliableProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 05/06/2024.
//

import UIKit

class AvaliableProductViewController: UIViewController , AddNewProductView {

    @IBOutlet weak var avaliableProductTableView: UITableView!
    
    var presenter: AddNewProductPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = AddNewProductPresenter(view: self)

        let cell = UINib(nibName: "AllProductsTableViewCell", bundle: nil)
        avaliableProductTableView.register(cell, forCellReuseIdentifier: "allProductCell")
        avaliableProductTableView.backgroundColor = UIColor.systemGray6
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigateBack()
    }
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
    
    @IBAction func addProduct(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let addProduct = storyboard.instantiateViewController(withIdentifier: "AddNewProductViewController") as! AddNewProductViewController
               addProduct.modalPresentationStyle = .fullScreen
                self.present(addProduct, animated: true, completion: nil)
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


extension AvaliableProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editableViewController = storyboard.instantiateViewController(withIdentifier: "editProductDestails") as? EditableProductDetailsViewController {
            editableViewController.modalPresentationStyle = .fullScreen
            present(editableViewController, animated: true, completion: nil)
        }
    }
}

