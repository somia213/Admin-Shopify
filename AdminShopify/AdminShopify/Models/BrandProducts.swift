//
//  BrandProducts.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//

import Foundation

struct BrandProductResponse: Codable {
    var products: [Product]
}

struct Product: Codable {
       var id: Int
       var title: String
       var body_html: String
       var vendor: String
       var created_at: String
       var handle: String
       var updated_at: String
       var published_at: String
       var template_suffix: String?
       var published_scope: String
       var status: String
       var admin_graphql_api_id: String
       var variants: [Variant]
       var options: [Option]
       var images: [BrandProductImage]
       
       enum CodingKeys: String, CodingKey {
           case id, title, body_html, vendor, created_at, handle, updated_at, published_at, template_suffix, published_scope, status, admin_graphql_api_id, variants, options, images
       }
}

struct BrandProductImage: Codable {
    var id: Int
        var src: String
}


struct Variant: Codable {
    var id: Int
       var product_id: Int
       var title: String
       var price: String
       var sku: String
       var position: Int
       var inventory_policy: String
       var compare_at_price: String?
       var fulfillment_service: String
       var option1: String
       var option2: String
       var option3: String?
       var created_at: String
       var updated_at: String
       var taxable: Bool
       var barcode: String?
       var grams: Int
       var weight: Double
       var weight_unit: String
       var inventory_item_id: Int
       var inventory_quantity: Int
       var old_inventory_quantity: Int
       var requires_shipping: Bool
       var admin_graphql_api_id: String
}
           


struct Option: Codable {
    var id: Int
        var product_id: Int
        var name: String
        var position: Int
        var values: [String]
}

