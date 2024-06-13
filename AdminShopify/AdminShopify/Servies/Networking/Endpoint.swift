//
//  EndPoints.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var baseURL: String { get }
    var url: String { get }
}

extension ShopifyEndpoint {
    var baseURL: String {
        switch self {
        case .updateProduct:
            return "https://\(SecretsSec.apiKey):\(SecretsSec.token)@mad44-alx-ios-4.myshopify.com"
        case .addProduct:
            return "https://\(SecretsSec.apiKey):\(SecretsSec.token)@mad44-alx-ios-4.myshopify.com"
        default:
            return "https://\(Secrets.apiKey):\(Secrets.token)@mad44-alx-ios-4.myshopify.com"
        }
    }
}

extension Endpoint {
    var url: String {
        return baseURL + path
    }
}

enum ShopifyEndpoint {
    case smartCollections
    case addProduct
    case productsByBrand(brand: String)
    case allProducts
    case getAllpriceRules
    case createPriceRule
    case productDetails(productId: Int)
    case updateProduct(productId: Int)
}

extension ShopifyEndpoint: Endpoint {
    var path: String {
        switch self {
        case .smartCollections:
            return "/admin/api/2024-04/smart_collections.json"
        case .addProduct:
            return "/admin/api/2024-04/products.json"
        case .productsByBrand(let brand):
            return "/admin/api/2024-04/products.json?vendor=\(brand)"
        case .allProducts:
            return "/admin/api/2024-04/products.json"
        case .getAllpriceRules:
            return "/admin/api/2024-04/price_rules.json"
        case .createPriceRule:
            return "/admin/api/2024-04/price_rules.json"
        case .productDetails(let productId):
            return "/admin/api/2024-04/products/\(productId).json"
        case .updateProduct(let productId):
            return "/admin/api/2024-04/products/\(productId).json"
        }
    }
}
