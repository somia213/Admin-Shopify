//
//  CreatePriceRule.swift
//  AdminShopify
//
//  Created by Somia on 10/06/2024.
//

import Foundation

struct PriceRuleRequest: Codable {
    let priceRule: PriceRule

    enum CodingKeys: String, CodingKey {
        case priceRule = "price_rule"
    }
}

// MARK: - PriceRule
struct PriceRule: Codable {
    let title, valueType, value, customerSelection: String
    let targetType, targetSelection, allocationMethod: String
    let startsAt, endsAt: String
    let prerequisiteCollectionIDS, entitledProductIDS: [String]
    let prerequisiteToEntitlementQuantityRatio: PrerequisiteToEntitlementQuantityRatio?
    let allocationLimit: Int?
    let usageLimit: Int?
    let oncePerCustomer: Bool?

    enum CodingKeys: String, CodingKey {
        case title
        case valueType = "value_type"
        case value
        case customerSelection = "customer_selection"
        case targetType = "target_type"
        case targetSelection = "target_selection"
        case allocationMethod = "allocation_method"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
        case prerequisiteCollectionIDS = "prerequisite_collection_ids"
        case entitledProductIDS = "entitled_product_ids"
        case prerequisiteToEntitlementQuantityRatio = "prerequisite_to_entitlement_quantity_ratio"
        case allocationLimit = "allocation_limit"
        case usageLimit = "usage_limit"
        case oncePerCustomer = "once_per_customer"
    }
}

// MARK: - PrerequisiteToEntitlementQuantityRatio
struct PrerequisiteToEntitlementQuantityRatio: Codable {
    let prerequisiteQuantity, entitledQuantity: Int

    enum CodingKeys: String, CodingKey {
        case prerequisiteQuantity = "prerequisite_quantity"
        case entitledQuantity = "entitled_quantity"
    }
}

// Example usage:
let priceRule = PriceRule(title: "Summer Sale 2024",
                          valueType: "percentage",
                          value: "-20.0",
                          customerSelection: "all",
                          targetType: "line_item",
                          targetSelection: "all",
                          allocationMethod: "across",
                          startsAt: "2024-06-21T00:00:00Z",
                          endsAt: "2024-09-21T23:59:59Z",
                          prerequisiteCollectionIDS: [],
                          entitledProductIDS: [],
                          prerequisiteToEntitlementQuantityRatio: nil,
                          allocationLimit: nil,
                          usageLimit: 1000,
                          oncePerCustomer: false)

let priceRuleRequest = PriceRuleRequest(priceRule: priceRule)

