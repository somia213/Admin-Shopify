//
//  SmartCollection.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//

import Foundation

struct SmartCollectionsResponse: Codable {
    let smartCollections: [SmartCollection]
}

struct SmartCollection: Codable {
    let id: Int
    let handle: String
    let title: String
    let updatedAt: String
    let bodyHtml: String
    let publishedAt: String
    let sortOrder: String
    let templateSuffix: String?
    let disjunctive: Bool
    let rules: [Rule]
    let publishedScope: String
    let adminGraphqlApiId: String
    let image: Image
}

struct Image: Codable {
    let createdAt: String
    let alt: String?
    let width: Int
    let height: Int
    let src: String
}

struct Rule: Codable {
    let column: String
    let relation: String
    let condition: String
}

