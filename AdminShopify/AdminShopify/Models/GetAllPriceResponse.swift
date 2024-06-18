//
//  GetAllPriceResponse.swift
//  AdminShopify
//
//  Created by Somia on 14/06/2024.
//

import Foundation

struct GetPriceRule: Codable {
        let id: Int
        let value_type: String
        let value: String
        let customer_selection: String
        let target_type: String
        let target_selection: String
        let allocation_method: String
        let allocation_limit: Int?
        let once_per_customer: Bool
        let usage_limit: Int
        let starts_at: String
        let ends_at: String
        let created_at: String
        let updated_at: String
        let title: String
        let admin_graphql_api_id: String
}

struct PriceRulesResponse: Codable {
    let price_rules: [GetPriceRule] 
}

