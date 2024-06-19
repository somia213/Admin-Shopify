
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
    
    func updateProductDetails(productId: String, updatedData: Data, completion: @escaping (Data?, Error?) -> Void) {
        let networkManager = NetworkManager.shared
        
        networkManager.updateResource(endpoint: .specificUpDateProduct, rootOfJson: .postProduct, productId: productId, body: updatedData) { (data, error) in
            completion(data, error)
        }
    }
    
    func updateVariantDetails(productId: String, variantId: String, updatedData: Data, completion: @escaping (Data?, Error?) -> Void) {
        let networkManager = NetworkManager.shared
        
        networkManager.updateResource(endpoint: .specificVariant, rootOfJson: .postVariant, productId: productId, variantId: variantId, body: updatedData) { (data, error) in
            completion(data, error)
        }
    }
}
