//
//  AddVarientProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 09/06/2024.
//

import UIKit

protocol AddVariantDelegate: AnyObject {
    func addVariant(variant: VariantRequest) 
    func addImage(src: String)
}

class AddVarientProductViewController: UIViewController {
    
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var addColor: UITextField!
    @IBOutlet weak var addSize: UITextField!
    @IBOutlet weak var addImage: UITextField!
    
    @IBOutlet weak var addQuantity: UITextField!
    weak var delegate: AddVariantDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    
    func navigateBack(){
        dismiss(animated: true, completion: nil)
    }

    @IBAction func doneBtn(_ sender: Any) {
        
        guard let price = addPrice.text,
                 let color = addColor.text,
                 let size = addSize.text,
                 let imagesString = addImage.text,
                 let quantityString = addQuantity.text,
                 let quantity = Int(quantityString) else {
                     return
           }

           let colors = color.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
           let sizes = size.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
           let images = imagesString.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

           guard !sizes.isEmpty, !colors.isEmpty, !images.isEmpty else {
               return
           }

           for (sizeValueIndex, sizeValue) in sizes.enumerated() {
               for (colorValueIndex, colorValue) in colors.enumerated() {
                   let imageIndex = min(images.count - 1, sizeValueIndex * colors.count + colorValueIndex)
                   let imageSrc = images[imageIndex]

                   if let imageURL = URL(string: imageSrc), UIApplication.shared.canOpenURL(imageURL) {
                       let variantTitle = "\(sizeValue) / \(colorValue)"
                       let sku = "AD-03-\(colorValue.lowercased())-\(sizeValue.lowercased())"

                       let variant = VariantRequest(
                           title: variantTitle,
                           price: price,
                           option1: sizeValue,
                           option2: colorValue,
                           inventory_quantity: quantity,
                           old_inventory_quantity: quantity,
                           sku: sku
                           // inventory_management: "shopify"
                       )

                       delegate?.addVariant(variant: variant)
                       delegate?.addImage(src: imageSrc)
                   } else {
                       showAlert(message: "Invalid image URL: \(imageSrc)")
                       return
                   }
               }
           }

           dismiss(animated: true, completion: nil)
       }

       func showAlert(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           present(alert, animated: true, completion: nil)
       }
    
}

