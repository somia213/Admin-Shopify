//
//  AddProducts.swift
//  AdminShopify
//
//  Created by Somia on 08/06/2024.
//

import Foundation

struct AddProductRequest: Codable {
    let product: ProductData
}

struct ProductData: Codable {
    let title: String
    let body_html: String
    let vendor: String
    let variants: [VariantRequest]
    let options: [OptionRequest]
    let images: [ImageRequest]
    
    
    
    enum CodingKeys: String, CodingKey {
            case title, body_html, vendor, variants, options, images
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(title, forKey: .title)
            try container.encode(body_html, forKey: .body_html)
            try container.encode(vendor, forKey: .vendor)
            try container.encode(variants, forKey: .variants)
            try container.encode(options, forKey: .options)
            try container.encode(images, forKey: .images)
        }
}


struct VariantRequest: Codable {
    let title: String
    let price: String
    let option1: String
    let option2: String
    let inventory_quantity: Int?
    let old_inventory_quantity: Int?
    let sku: String
    var inventory_management: String = "shopify"
}

struct OptionRequest: Codable {
    let name: String
    let values: [String]
}

struct ImageRequest: Codable {
    var id: Int?
    let src: String
}

