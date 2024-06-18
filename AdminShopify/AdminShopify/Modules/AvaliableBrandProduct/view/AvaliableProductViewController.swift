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
        if let imageUrlString = product.images.first?.src, let imageUrl = URL(string: imageUrlString) {
            cell.productItemImg.kf.setImage(with: imageUrl)
        } else {
            cell.productItemImg.image = UIImage(named: "png-clipart-gray-icons-lock-2")
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Delete Product", message: "Are you sure you want to delete this product?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.deleteProduct(at: indexPath)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func deleteProduct(at indexPath: IndexPath) {
        let productId = viewModel.products[indexPath.row].id
        viewModel.deleteProduct(productId: productId) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.viewModel.products.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.avaliableProductTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            } else {
                let alertController = UIAlertController(title: "Error", message: "Failed to delete the product. Please try again later.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var product = viewModel.products[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editableViewController = storyboard.instantiateViewController(withIdentifier: "editProductDestails") as? EditableProductDetailsViewController {
            
            editableViewController.viewModel.product = product
            
            editableViewController.modalPresentationStyle = .fullScreen
            present(editableViewController, animated: true, completion: nil)
        }
    }
}






