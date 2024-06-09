//
//  AddNewProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import UIKit

class AddNewProductViewController: UIViewController, AddNewProductView {
    
    @IBOutlet weak var addProductTitle: UITextField!
    @IBOutlet weak var addProductVendor: UITextField!
    @IBOutlet weak var addProductPrice: UITextField!
    @IBOutlet weak var addProductColor: UITextField!
    @IBOutlet weak var addProductSize: UITextField!
    @IBOutlet weak var addProductImageURL: UITextField!
    @IBOutlet weak var addProductDescription: UITextField!
    @IBOutlet weak var addProductQuantity: UITextField!
    
    var viewModel: AddProductViewModel!
    
    var presenter: AddNewProductPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)
        viewModel = AddProductViewModel(networkManager: NetworkManager())
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        presenter.goBack()
    }
    
    func navigateBack() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func sendAddProduct(_ sender: Any) {
        guard let title = addProductTitle.text,
                     let vendor = addProductVendor.text,
                     let priceString = addProductPrice.text,
                     let price = Double(priceString),
                     let imageSrc = addProductImageURL.text,
                     let description = addProductDescription.text,
                     let quantityString = addProductQuantity.text,
                     let quantity = Int(quantityString),
                     let size = addProductSize.text,
                     let color = addProductColor.text
               else {
                   print("Invalid input")
                   return
               }
               
               let variantTitle = "\(size), \(color)"
               
               let variant = AddProductVariant(
                   title: variantTitle,
                   price: "\(price)",
                   inventory_quantity: quantity,
                   option1: size,
                   option2: color
               )
               
               let product = AddProductRequest(
                   product: AddProductData(
                       title: title,
                       body_html: description,
                       vendor: vendor,
                       variants: [variant],
                       images: [AddProductImage(src: imageSrc)]
                   )
               )
               
               if let requestData = try? JSONEncoder().encode(product),
                  let requestDataString = String(data: requestData, encoding: .utf8) {
                   print("Request Body:")
                   print(requestDataString)
               }
               
               viewModel.addProduct(product: product) { result in
                   switch result {
                   case .success(let success):
                       if success {
                           DispatchQueue.main.async {
                               self.dismiss(animated: true, completion: nil)
                               print("data add succssfully")
                           }
                       } else {
                           print("Failed to add product")
                       }
                   case .failure(let error):
                       print("Error adding product: \(error)")
                   }
               }
           }
       }
