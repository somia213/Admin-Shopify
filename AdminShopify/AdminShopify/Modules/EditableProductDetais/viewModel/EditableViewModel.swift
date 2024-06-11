
//  EditableViewModel.swift
//  AdminShopify
//
//  Created by Somia on 11/06/2024.


import Foundation

class EditableProductDetailsViewModel {
    var product: Product?
    var selectedSize: String?
    
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
}
