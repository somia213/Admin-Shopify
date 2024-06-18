//
//  AddNewProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import UIKit

class AddNewProductViewController: UIViewController, AddNewProductView {
    func navigateBack() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var addProductTitle: UITextField!
    @IBOutlet weak var addProductVendor: UITextField!
    @IBOutlet weak var addProductDescription: UITextField!
    
    
    var viewModel: AddProductViewModel!
    var presenter: AddNewProductPresenter!
    
    var variants: [VariantRequest] = []
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
        
        guard let productRequest = viewModel.constructProduct(
            title: addProductTitle.text,
            description: addProductDescription.text,
            vendor: addProductVendor.text,
            variants: variants,
            images: images
        ) else {
            showErrorAlert(message: "Please fill in all required fields.")
            return
        }
        
        viewModel.addProduct(product: productRequest) { [weak self] result in
            switch result {
            case .success(let success):
                print("Product added successfully: \(success)")
                self?.showSuccessAlert()
            case .failure(let error):
                print("Failed to add product: \(error.localizedDescription)")
                self?.showErrorAlert(message: "Product added successfully.")
            }
        }
    }
    
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Product added successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
     

extension AddNewProductViewController: AddVariantDelegate {
            func addVariant(variant: VariantRequest) {
                    variants.append(variant)
                }
                
                func addImage(src: String) {
                    images.append(src)
            }
    }

