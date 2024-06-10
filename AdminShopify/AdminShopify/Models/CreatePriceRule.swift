//
//  CreatePriceRule.swift
//  AdminShopify
//
//  Created by Somia on 10/06/2024.
//

import Foundation

struct PriceRuleResponse: Codable {
    let priceRules: [PriceRule]
}
    struct PriceRule: Codable {
        let title: String
        let starts_at: String
        let ends_at: String
        let type: String
        let discountAmount: String
        let minSubTotal: Double?
        let usage: Int?
    }
