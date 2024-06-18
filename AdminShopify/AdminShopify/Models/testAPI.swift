//
//  testAPI.swift
//  AdminShopify
//
//  Created by Somia on 13/06/2024.
//


import Foundation

// MARK: - Welcome1
struct TestProduct {
    let products: TestProductToApi
}

// MARK: - Product

struct TestProductToApi {
    let id: Int
    let title, body_html, vendor: String
    let product_type: ProductType
    let created_at: Date
    let handle: String
    let updated_at, published_at: Date
    let template_suffix: NSNull
    let published_scope: PublishedScope
    let tags: String
    let status: Status
    let admin_graphql_api_id: String
    let variants: [TestVariant]
    let options: [TestOption]
    let images: [TestImage]
    let image: Image?
}

// MARK: - Image
struct TestImage {
    let id: Int
    let alt: NSNull
    let position, product_id: Int
    let created_at, updated_at: Date
    let admin_graphql_api_id: String
    let width, height: Int
    let src: String
    let variant_ids: [Any?]
}

// MARK: - Option
struct TestOption {
    let id, productID: Int
    let name: Name
    let position: Int
    let values: [String]
}

enum Name {
    case color
    case size
}

enum ProductType {
    case accessories
    case empty
    case shoes
    case tShirts
}

enum PublishedScope {
    case global
}

enum Status {
    case active
}

// MARK: - Variant
struct TestVariant {
    let id, product_id: Int
    let title, price, sku: String
    let position: Int
    let inventory_policy: InventoryPolicy
    let compare_at_price: String?
    let fulfillment_service: FulfillmentService
    let inventory_management: InventoryManagement?
    let option1: String
    let option2: String
    let option3: NSNull
    let created_at, updated_at: Date
    let taxable: Bool
    let barcode: NSNull
    let grams: Int
    let weight: Double
    let weight_unit: WeightUnit
    let inventory_item_id, inventory_quantity, old_inventory_quantity: Int
    let requires_shipping: Bool
    let admin_graphql_api_id: String
    let image_id: NSNull
}

enum FulfillmentService {
    case manual
}

enum InventoryManagement {
    case shopify
}

enum InventoryPolicy {
    case deny
}

enum Option2 {
    case beige
    case black
    case blue
    case burgandy
    case gray
    case green
    case lightBrown
    case red
    case white
    case yellow
}

enum WeightUnit {
    case kg
}
