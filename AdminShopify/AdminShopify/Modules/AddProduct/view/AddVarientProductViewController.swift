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
        guard let priceString = addPrice.text,
              let price = Int(priceString) else {
                  showAlert(message: "Invalid price entered. Please enter an integer.")
                  return
              }
        
        guard let color = addColor.text, !color.isEmpty else {
            showAlert(message: "Color cannot be empty.")
            return
        }
        
        guard let size = addSize.text, !size.isEmpty else {
            showAlert(message: "Size cannot be empty.")
            return
        }
        
        let colorCharacterSet = CharacterSet.letters
            guard color.rangeOfCharacter(from: colorCharacterSet.inverted) == nil else {
                showAlert(message: "Invalid input for color. Only alphabetic characters are allowed.")
                return
            }
        
        let imagesString = addImage.text ?? ""
        let quantityString = addQuantity.text ?? ""
        
        guard let quantity = Int(quantityString) else {
            showAlert(message: "Invalid quantity entered. Please enter an integer.")
            return
        }
        
        let colors = color.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let sizes = size.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let images = imagesString.components(separatedBy: "-").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        guard !sizes.isEmpty, !colors.isEmpty, !images.isEmpty else {
            showAlert(message: "Sizes, colors, or images cannot be empty.")
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
                        price: "\(price)",
                        option1: sizeValue,
                        option2: colorValue,
                        inventory_quantity: quantity,
                        old_inventory_quantity: quantity,
                        sku: sku
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
