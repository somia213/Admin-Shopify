//
//  GetDiscountCodes.swift
//  AdminShopify
//
//  Created by Somia on 15/06/2024.
//

import Foundation

struct DiscountCodeResponse: Codable {
    let discountCodes: [DiscountCode]

    enum CodingKeys: String, CodingKey {
        case discountCodes = "discount_codes"
    }
}

struct DiscountCode: Codable {
    let code: String
    let id: Int
    let price_rule_id: Int
}
