//
//  AddProducts.swift
//  AdminShopify
//
//  Created by Somia on 08/06/2024.
//

import Foundation

struct AddProductRequest: Codable {
    let products: [ProductResponse]
}

struct ProductResponse: Codable {
    let title: String
    let vendor: String
    let body_html: String
    let variants: [AddProductVariant]
    let options: [OneOption]
    let images: [AddProductImage]
    let image: AddProductImage?
}

struct AddProductVariant: Codable {
    let title: String
       let price: String
       let option1: String
       let option2: String
       let inventory_quantity: Int?
       let old_inventory_quantity: Int?
       let sku: String
}

struct OneOption : Codable{
    let name: String
       let position: Int?
       let values: [String]
}

struct AddProductImage: Codable {
   
        let src: String
        
}


