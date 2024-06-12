
//  EditableViewModel.swift
//  AdminShopify
//
//  Created by Somia on 11/06/2024.


import Foundation

class EditableProductDetailsViewModel {
    var product: Product?
    var selectedSize: String?
    var selectedColor: String?
    var selectedImageSrc: String?
    
    func updatePriceAndQuantity() -> (price: String?, quantity: String?) {
        guard let product = product, let selectedSize = selectedSize else {
            return (nil, nil)
        }
        
        if let variant = product.variants.first(where: { $0.option1 == selectedSize }) {
            let price = variant.price
            let quantity = "\(variant.inventory_quantity)"
            return (price, quantity)
        }
        
        return (nil, nil)
    }
       
       func updateTitle(newTitle: String) {
           product?.title = newTitle
       }
       
       func updateBodyHTML(newBodyHTML: String) {
           product?.body_html = newBodyHTML
       }
       
       
       func updatePriceAndQuantity(newPrice: String, newQuantity: Int) {
           guard let selectedSize = selectedSize else {
               return
           }
           
           if let variantIndex = product?.variants.firstIndex(where: { $0.option1 == selectedSize }) {
               product?.variants[variantIndex].price = newPrice
               product?.variants[variantIndex].inventory_quantity = newQuantity
           }
       }
       
   
    func updateSize(newSize: String) {
        guard let selectedSize = selectedSize else {
            return
        }
        
        if let variantIndex = product?.variants.firstIndex(where: { $0.option1 == selectedSize }) {
            product?.variants[variantIndex].option1 = newSize
        }
    }
    func updateColor(newColor: String) {
            guard let selectedColor = selectedColor else {
                return
            }

            if let variantIndex = product?.variants.firstIndex(where: { $0.option2 == selectedColor }) {
                product?.variants[variantIndex].option2 = newColor
            }
        }

        func updateImageSrc(newImageSrc: String) {
            selectedImageSrc = newImageSrc
        }
    
}

