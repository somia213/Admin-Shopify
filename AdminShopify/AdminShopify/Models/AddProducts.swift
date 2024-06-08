//
//  AddProducts.swift
//  AdminShopify
//
//  Created by Somia on 08/06/2024.
//

import Foundation

struct AddProductRequest: Codable {
    let product: AddProductData
}

struct AddProductData: Codable {
    let title: String
    let body_html: String
    let vendor: String
    let variants: [AddProductVariant]
    let images: [AddProductImage]
}

struct AddProductVariant: Codable {
    let title: String
    let price: String
    let inventory_quantity: Int
    let option1: String
    let option2: String
}

struct AddProductImage: Codable {
    let src: String
}
