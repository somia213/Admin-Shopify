//
//  PostDiscountOrder.swift
//  AdminShopify
//
//  Created by Somia on 15/06/2024.
//

import Foundation

struct PostDiscountCodeRequest: Codable {
    let discount_code: PostDiscountCode
}

struct PostDiscountCode: Codable {
    let code: String
}
