//
//  EndPoints.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//

import Foundation

protocol Endpoint {
    var path: String { get }
}

extension Endpoint {
    var baseURL: String {
           return "https://\(Secrets.apiKey):\(Secrets.token)@mad44-alx-ios-4.myshopify.com"

    }

    var url: String {
        return baseURL + path
    }
}

enum ShopifyEndpoint {
    case smartCollections
}

extension ShopifyEndpoint: Endpoint {
    var path: String {
        switch self {
        case .smartCollections:
            return "/admin/api/2024-04/smart_collections.json"
        }
    }
}
