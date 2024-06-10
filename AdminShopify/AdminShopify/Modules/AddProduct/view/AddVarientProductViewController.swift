//
//  AddVarientProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 09/06/2024.
//

import UIKit

protocol AddVariantDelegate: AnyObject {func addVariant(variant: AddProductVariant) 
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
    
    @IBAction func doneBtn(_ sender: Any) {
        
        guard let price = addPrice.text,
                     let color = addColor.text,
                     let size = addSize.text,
                     let image = addImage.text,
                     let quantityString = addQuantity.text,
                     let quantity = Int(quantityString) else {
                   return
               }
               
               let variantTitle = "\(size) / \(color)"
               let sku = "AD-03-\(color)-\(size)"
        
        let variant = AddProductVariant(
            title: variantTitle,
            price: price,
            option1: size,
            option2: color,
            inventory_quantity: quantity,
            old_inventory_quantity: quantity,
            sku: sku
        )
               
               delegate?.addVariant(variant: variant)
               delegate?.addImage(src: image)
               dismiss(animated: true, completion: nil)
           }
    
    @IBAction func closeBtn(_ sender: Any) {
        navigateBack()
    }
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
    
}

