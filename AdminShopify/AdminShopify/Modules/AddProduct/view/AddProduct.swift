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
        let productRequest = constructProduct()
            let productData = productRequest.product
            viewModel.addProduct(product: productData) { [weak self] result in
                switch result {
                case .success(let success):
                    print("Product added successfully: \(success)")
                    self?.showSuccessAlert()
                case .failure(let error):
                    print("Failed to add product: \(error.localizedDescription)")
                    self?.showErrorAlert()
                }
            }
        }

    func constructProduct() -> AddProductRequest {
        var variantsData: [VariantRequest] = []
        for variant in variants {
            let variantTitle = "\(variant.option1) / \(variant.option2)"
            let sku = "AD-03-\(variant.option2.lowercased())-\(variant.option1.lowercased())"
            let variantData = VariantRequest(
                title: variantTitle,
                price: variant.price,
                option1: variant.option1,
                option2: variant.option2,
                inventory_quantity: variant.inventory_quantity,
                old_inventory_quantity: variant.old_inventory_quantity,
                sku: sku
            )
            variantsData.append(variantData)
        }
        
        let sizesOption = OptionRequest(name: "Size", values: variants.map { $0.option1 })
        let colorsOption = OptionRequest(name: "Color", values: variants.map { $0.option2 })
        
        let productData = ProductData(
            title: addProductTitle.text ?? "",
            body_html: addProductDescription.text ?? "",
            vendor: addProductVendor.text ?? "",
            variants: variantsData,
            options: [sizesOption, colorsOption],
            images: images.map { ImageRequest(src: $0) }
        )
        
        return AddProductRequest(product: productData)
    }


            func showSuccessAlert() {
                let alert = UIAlertController(title: "Success", message: "Product added successfully.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            
            func showErrorAlert() {
                let alert = UIAlertController(title: "Error", message: "Failed to add product. Please try again later.", preferredStyle: .alert)
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
