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
        let endpoint = TestEndpoint.specificDiscountOrder.rawValue.replacingOccurrences(of: "{priceRuleId}", with: "\(priceRuleId)")
        
        let requestBody: [String: Any] = [
            "discount_code": [
                "code": code
            ]
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            
            guard let endpointURL = URL(string: "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint)") else {
                let error = NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid endpoint"])
                print("Invalid endpoint: \(endpoint)")
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }
            
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(TOKEN, forHTTPHeaderField: "X-Shopify-Access-Token")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Network request failed with error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 201:
                        print("Discount code added successfully")
                        DispatchQueue.main.async {
                            completionHandler(.success(()))
                        }
                    case 404:
                        let error = NSError(domain: "YourDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Discount code not found"])
                        print("Discount code not found. Status code: \(httpResponse.statusCode)")
                        DispatchQueue.main.async {
                            completionHandler(.failure(error))
                        }
                    case 401:
                        let error = NSError(domain: "YourDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unauthorized access"])
                        print("Unauthorized access. Status code: \(httpResponse.statusCode)")
                        DispatchQueue.main.async {
                            completionHandler(.failure(error))
                        }
                    default:
                        let error = NSError(domain: "YourDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to add discount code"])
                        print("Failed to add discount code. Status code: \(httpResponse.statusCode)")
                        DispatchQueue.main.async {
                            completionHandler(.failure(error))
                        }
                    }
                } else {
                    let error = NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    print("Failed to add discount code. Invalid response format")
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            }.resume()
        } catch {
            print("Error occurred: \(error.localizedDescription)")
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }

    func deleteDiscountCode(discountCodeId: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = ShopifyEndpoint.deleteDiscountCode(priceRuleId: priceRuleId, discountCodeId: discountCodeId)
        
        networkManager.deleteFromAPI(endpoint: endpoint) { result in
            switch result {
            case .success:
                print("Discount code deleted successfully.")
                completionHandler(.success(()))
            case .failure(let error):
                print("Failed to delete discount code: \(error.localizedDescription)")
                completionHandler(.failure(error))
            }
        }
    }

}
