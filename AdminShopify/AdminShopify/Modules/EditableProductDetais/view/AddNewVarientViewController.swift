//
//  AddNewVarientViewController.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//

import UIKit

protocol AddNewVarientViewControllerDelegate: AnyObject {
    func variantDetailsUpdated(with variant: Variant)
}

class AddNewVarientViewController: UIViewController , AddNewProductView {
    
    var viewModel = EditableProductDetailsViewModel()
    weak var delegate: AddNewVarientViewControllerDelegate?


    @IBOutlet weak var AddNewVarientViewSize: UITextField!
    
    @IBOutlet weak var AddNewVarientPrice: UITextField!
    var presenter: AddNewProductPresenter!

    @IBOutlet weak var AddNewVarientColor: UITextField!
    
    @IBOutlet weak var AddNewVarientQuantity: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let firstVariant = viewModel.newVariants.first {
                AddNewVarientViewSize.text = firstVariant.option1
                AddNewVarientPrice.text = firstVariant.price
                AddNewVarientColor.text = firstVariant.option2
                AddNewVarientQuantity.text = "\(firstVariant.inventory_quantity)"
            }

            presenter = AddNewProductPresenter(view: self)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        guard let updatedSize = AddNewVarientViewSize.text,
              let updatedPrice = AddNewVarientPrice.text,
              let updatedColor = AddNewVarientColor.text,
              let updatedQuantityStr = AddNewVarientQuantity.text,
//              let updatedQuantity = Int(updatedQuantityStr),
              !viewModel.productIdString.isEmpty else {
                  print("Invalid input or missing productIdString")
                  return
        }

        let updateData: [String: Any] = [
            "variant": [
                "id": viewModel.newVariants.first?.id ?? "",
                "option1": updatedSize,
                "option2": updatedColor,
                "price": updatedPrice,
                // "inventory_quantity": updatedQuantity // Shopify API no longer supports direct inventory_quantity updates
            ]
        ]

        guard let encodedData = try? JSONSerialization.data(withJSONObject: updateData) else {
            print("Failed to encode updated data.")
            return
        }

        viewModel.updateVariantDetails(productId: viewModel.productIdString, variantId: "\(viewModel.newVariants.first?.id ?? 0)", updatedData: encodedData) {
            data, error in
            if let error = error {
                print("Failed to update variant: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async { [self] in
                    if let updatedVariant = self.viewModel.newVariants.first {
                        delegate?.variantDetailsUpdated(with: updatedVariant)
                    }
                    navigateBack()
                }
            }
        }
    }

    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
}
