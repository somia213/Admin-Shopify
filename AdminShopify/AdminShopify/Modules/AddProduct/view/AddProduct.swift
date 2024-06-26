//
//  AddNewProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import UIKit

class AddNewProductViewController: UIViewController, AddNewProductView, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.dataSource = self
            addProductVendor.inputView = pickerView
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return viewModel.vendors.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return viewModel.vendors[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            addProductVendor.text = viewModel.vendors[row]
            addProductVendor.resignFirstResponder()
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
        
        guard let title = addProductTitle.text, !title.isEmpty,
                 let vendor = addProductVendor.text, !vendor.isEmpty,
                 let description = addProductDescription.text, !description.isEmpty
           else {
               showErrorAlert(message: "Please fill in all required fields.")
               return
           }
        
        guard !viewModel.variants.isEmpty else {
                    showErrorAlert(message: "Please enter at least one variant.")
                    return
                }
        
        guard let productRequest = viewModel.constructProduct(
                      title: title,
                      description: description,
                      vendor: vendor,
                      variants: viewModel.variants.map { variant in
                          var updatedVariant = variant
                          updatedVariant.inventory_management = "shopify"
                          return updatedVariant
                      },
                      images: viewModel.images
                  ) else {
                  showErrorAlert(message: "Invalid data entered.")
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
    
    
    @IBAction func comboBoxBtn(_ sender: Any) {
        addProductVendor.becomeFirstResponder()
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
