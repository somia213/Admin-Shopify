//
//  DiscountCodeViewModel.swift
//  AdminShopify
//
//  Created by Somia on 15/06/2024.
//

import Foundation

class DiscountCodeViewModel {
    private let networkManager: NetworkServicing
    var priceRuleId: Int
    var discountCodes: [DiscountCode] = []
    
    var dataUpdated: (() -> Void)?
    
    init(priceRuleId: Int, networkManager: NetworkServicing = NetworkManager()) {
        self.priceRuleId = priceRuleId
        self.networkManager = networkManager
    }
    
    func fetchDiscountCodes() {
        let endpoint = ShopifyEndpoint.getDiscountCodes(priceRuleId: priceRuleId)

        networkManager.fetchDataFromAPI(endpoint: endpoint) { [weak self] (response: DiscountCodeResponse?) in
            guard let self = self else { return }
            if let response = response {
                self.discountCodes = response.discountCodes
                self.dataUpdated?()
            } else {
                print("Failed to fetch discount codes.")
            }
        }
    }
    
    func postDiscountCode(code: String, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = ShopifyEndpoint.postDiscountCode(priceRuleId: priceRuleId)
        
        let requestBody: [String: Any] = [
            "discount_code": [
                "code": code
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            
            networkManager.postDataToApi(endpoint: .specificDiscountOrder, rootOfJson: .postiscountOrder, body: jsonData) { (data, error) in
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                
                
                guard let statusCode = (data as? HTTPURLResponse)?.statusCode, statusCode == 200 else {
                    let error = NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status code"])
                    completionHandler(.failure(error))
                    return
                }
                
                completionHandler(.success(()))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
