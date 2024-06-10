//
//  AddNewProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import UIKit

class AddNewProductViewController: UIViewController, AddNewProductView {
    func navigateBack() {
    }
    
    
    @IBOutlet weak var addProductTitle: UITextField!
    @IBOutlet weak var addProductVendor: UITextField!
    @IBOutlet weak var addProductDescription: UITextField!
    
    
    var viewModel: AddProductViewModel!
    var presenter: AddNewProductPresenter!
    
    var variants: [AddProductVariant] = []
       var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)
        viewModel = AddProductViewModel(networkManager: NetworkManager())
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        presenter.goBack()
    }
    
    @IBAction func addVariant(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVariantVC = storyboard.instantiateViewController(withIdentifier: "AddVarientProductViewController") as! AddVarientProductViewController

        newVariantVC.delegate = self
        newVariantVC.modalPresentationStyle = .fullScreen

            present(newVariantVC, animated: true, completion: nil)
    }
    
    @IBAction func sendAddProduct(_ sender: Any) {
        let product = constructProduct()
              viewModel.addProduct(product: product) { [weak self] result in
                  switch result {
                  case .success(let success):
                      print("Product added successfully: \(success)")
                      self?.navigateBack()
                  case .failure(let error):
                      print("Failed to add product: \(error.localizedDescription)")
                      let alert = UIAlertController(title: "Error", message: "Failed to add product. Please try again later.", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                      self?.present(alert, animated: true, completion: nil)
                  }
              }
          }
          
          func constructProduct() -> AddProductRequest {
              // Define options
              let sizesOption = OneOption(name: "Size", position: nil, values: variants.map { $0.option1 })
              let colorsOption = OneOption(name: "Color", position: nil, values: variants.map { $0.option2 })
              
              // Define product
              let product = ProductResponse(
                  title: addProductTitle.text ?? "",
                  vendor: addProductVendor.text ?? "",
                  body_html: addProductDescription.text ?? "",
                  variants: variants,
                  options: [sizesOption, colorsOption],
                  images: images.map { AddProductImage(src: $0) },
                  image: nil // Set this to nil for now, as it's not being provided
              )
              
              return AddProductRequest(products: [product])
          }
      }

      extension AddNewProductViewController: AddVariantDelegate {
          func addVariant(variant: AddProductVariant) {
              variants.append(variant)
          }
          
          func addImage(src: String) {
              images.append(src)
          }
      }
