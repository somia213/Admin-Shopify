//
//  AvaliableProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 05/06/2024.
//

import UIKit

class AvaliableProductViewController: UIViewController , AddNewProductView {

    @IBOutlet weak var avaliableProductTableView: UITableView!
    var brandTitle: String?
    
    var presenter: AddNewProductPresenter!
    var viewModel: BrandProductViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = AddNewProductPresenter(view: self)
        viewModel = BrandProductViewModel()
        
        viewModel.dataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.avaliableProductTableView.reloadData()
            }
        }

        if let brandTitle = brandTitle {
            viewModel.fetchData(forBrand: brandTitle)
        }

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

extension AvaliableProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allProductCell", for: indexPath) as! AllProductsTableViewCell
        
        let products = viewModel.products 
        let product = products[indexPath.row]
        
        if let imageUrl = URL(string: product.images.first!.src) {
            cell.productItemImg.kf.setImage(with: imageUrl)
        }
        cell.productItemDescription.text = product.body_html
        if let inventoryQuantity = product.variants.first?.inventory_quantity {
            cell.productItemCountInStore.text = "\(inventoryQuantity) In store"
        } else {
            cell.productItemCountInStore.text = "Unavailable"
        }

        if let price = product.variants.first?.price {
            cell.productItemPrice.text = "\(price)$"
        } else {
            cell.productItemPrice.text = "Price Unavailable"
        }
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

