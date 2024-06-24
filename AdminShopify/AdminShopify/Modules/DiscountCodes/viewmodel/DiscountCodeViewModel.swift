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

            let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint)"
            guard let url = URL(string: urlString) else {
                let error = NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                print("Invalid URL: \(urlString)")
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }

            print("Posting to URL: \(url)")
            print("HTTP Method: POST")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let base64EncodedCredentials = "\(API_KEY):\(TOKEN)".data(using: .utf8)?.base64EncodedString()
            request.setValue("Basic \(base64EncodedCredentials)", forHTTPHeaderField: "Authorization")
            
            print("Headers: \(request.allHTTPHeaderFields ?? [:])")

            if let requestBodyString = String(data: jsonData, encoding: .utf8) {
                print("Request Body: \(requestBodyString)")
            }
            
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle response
                if let error = error {
                    print("Failed to add discount code: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    let error = NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                    print("Failed to add discount code. Invalid response format")
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                    return
                }

                print("HTTP Response Status Code: \(httpResponse.statusCode)")

                do {
                    if let data = data {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(jsonResponse)")
                    }

                    switch httpResponse.statusCode {
                    case 201:
                        print("Discount code added successfully")
                        DispatchQueue.main.async {
                            completionHandler(.success(()))
                        }
                    case 400..<500:
                        let errorMessage = "Bad request: \(httpResponse.statusCode)"
                        let error = NSError(domain: "YourDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        print("Failed to add discount code. \(errorMessage)")
                        DispatchQueue.main.async {
                            completionHandler(.failure(error))
                        }
                    default:
                        let errorMessage = "Failed to add discount code. Status code: \(httpResponse.statusCode)"
                        let error = NSError(domain: "YourDomain", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                        print(errorMessage)
                        DispatchQueue.main.async {
                            completionHandler(.failure(error))
                        }
                    }
                } catch {
                    let errorMessage = "Error parsing JSON response: \(error.localizedDescription)"
                    let error = NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                    print(errorMessage)
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            }.resume()
        } catch {
            let errorMessage = "Error occurred: \(error.localizedDescription)"
            let error = NSError(domain: "YourDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            print(errorMessage)
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
