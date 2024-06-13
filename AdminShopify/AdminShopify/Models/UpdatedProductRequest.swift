////
////  UpdatedProductRequest.swift
////  AdminShopify
////
////  Created by Somia on 11/06/2024.
////
//
//import Foundation
//
//struct updatedProductRequest: Codable {
//    var id: Int
//    var title: String
//    var body_html: String
//    var variants: [AllVariant]
//    var options: [AllOption]
//    var images: [AllProductImage]
//}
//
//struct updateVariant: Codable {
//    var price: String
//    var inventory_quantity: Int
//}
//
//struct updateOption: Codable {
//    var name: String
//    var values: [String]
//}
//




struct UpdatedProductRequest: Codable {
    var product: UpdateProduct
}

struct UpdateProduct: Codable {
    var title: String
    var body_html: String
    var images: [UpdateProductImage]
}

struct UpdateProductImage: Codable {
    var src: String
}

