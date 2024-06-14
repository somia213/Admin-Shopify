//
//  CreatePriceRuleViewModel.swift
//  AdminShopify
//
//  Created by Somia on 14/06/2024.
//

// AddPriceRuleViewModel.swift

import Foundation

class AddPriceRuleViewModel {
    let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func addPriceRule(title: String,
                      valueType: String,
                      value: String,
                      customerSelection: String,
                      startsAt: Date,
                      endsAt: Date,
                      usageLimit: Int,
                      completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]
        let startsAtString = dateFormatter.string(from: startsAt)
        let endsAtString = dateFormatter.string(from: endsAt)
        
        let priceRule = PriceRule(title: title,
                                  valueType: valueType,
                                  value: value,
                                  customerSelection: customerSelection,
                                  targetType: "line_item",
                                  targetSelection: "all",
                                  allocationMethod: "across",
                                  startsAt: startsAtString,
                                  endsAt: endsAtString,
                                  prerequisiteCollectionIDS: [],
                                  entitledProductIDS: [],
                                  prerequisiteToEntitlementQuantityRatio: nil,
                                  allocationLimit: nil,
                                  usageLimit: usageLimit,
                                  oncePerCustomer: false)
        
        do {
            let encoder = JSONEncoder()
            let priceRuleRequest = PriceRuleRequest(priceRule: priceRule)
            let body = try encoder.encode(priceRuleRequest)
            
            networkManager.postDataToApi(endpoint: .specificPriceRule, rootOfJson: .postPriceRule, body: body) { (data: Data?, error: Error?) in
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                
                guard let responseData = data else {
                    completionHandler(.failure(MyError.noDataInResponse))
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(TestAddPriceRuleResponse.self, from: responseData)
                    completionHandler(.success(response.success))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}

enum MyError: Error {
    case noDataInResponse
}
struct TestAddPriceRuleResponse: Codable {
    let success: Bool
}
