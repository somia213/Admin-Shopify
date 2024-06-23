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
    @IBOutlet weak var doneImage: UIImageView!
    
    
    var viewModel: AddProductViewModel!
    var presenter: AddNewProductPresenter!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)
        viewModel = AddProductViewModel(networkManager: NetworkManager())
        
        doneImage.isHidden = true

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
            variants: viewModel.variants,
            images: viewModel.images
        ) else {
            showErrorAlert(message: "Please fill in all required fields.")
            return
        }
        
        viewModel.addProduct(product: productRequest) { [weak self] result in
            switch result {
            case .success(let success):
                print("Product added successfully: \(success)")
                self?.showSuccessAlert()
                self?.showSuccessImageAndNavigateBack()
            case .failure(let error):
                print("Failed to add product: \(error.localizedDescription)")
                self?.showSuccessImageAndNavigateBack()
            }
        }
    }
    
    private func showSuccessImageAndNavigateBack() {
        doneImage.isHidden = false
        UIView.animate(withDuration: 1.0, animations: {
            self.doneImage.alpha = 1.0
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.doneImage.alpha = 0.0
                }) { _ in
                    self.doneImage.isHidden = true
                    self.navigateBack()
                }
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
        viewModel.addVariant(variant: variant)
    }

    func addImage(src: String) {
        viewModel.addImage(src: src)
    }
}

