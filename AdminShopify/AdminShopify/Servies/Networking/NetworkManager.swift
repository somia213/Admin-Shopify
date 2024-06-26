//
//  NetworkManager.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import Foundation
import Alamofire

enum Root: String {
    case postProduct = "products"
    case postPriceRule = "price_rule"
    case postDiscountCode = "discount_codes"
    case postVariant = "variants"
    case postInventoryQuantity = "inventory_level"
    
}

enum TestEndpoint: String {
    case specificProduct = "products.json"
    case specificPriceRule = "price_rules.json"
    case specificDiscountOrder = "price_rules/{priceRuleId}/discount_codes.json"
    case specificUpDateProduct = "products/{productId}.json"
    case specificVariant = "products/{productId}/variants/{variantId}.json"
    case updateVariantInventory = "inventory_levels/set.json"

        var endpointString: String {
            switch self {
            case .specificProduct, .specificPriceRule:
                return self.rawValue
            case .specificDiscountOrder:
                return self.rawValue
            case .specificUpDateProduct, .specificVariant, .updateVariantInventory:
                return self.rawValue
                }
    }
}

let API_KEY = Secrets.apiKey
let TOKEN = Secrets.token
let baseUrl = "@mad44-alx-ios-4.myshopify.com/admin/api/2024-01/"

enum NetworkError: Error {
    case failedToAddProduct
    case unknownError
}


protocol NetworkServicing {
    
    func fetchDataFromAPI<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (T?) -> Void)
   
    func postDataToApi(endpoint: TestEndpoint, rootOfJson: Root, body: Data, completion: @escaping (Data?, Error?) -> Void)
    func deleteFromAPI(endpoint: ShopifyEndpoint, completionHandler: @escaping (Result<Void, Error>) -> Void)
    func updateResource(endpoint: TestEndpoint, rootOfJson: Root, productId: String, variantId: String?, body: Data, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkManager: NetworkServicing {
        
        static let shared = NetworkManager()
        
    func fetchDataFromAPI<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (T?) -> Void) {
        AF.request(endpoint.url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        print("No data received from the server.")
                        completionHandler(nil)
                        return
                    }
                    print(String(data: data, encoding: .utf8) ?? "Unable to print response data.")
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(result)
                    } catch {
                        print("Decoding error: \(error)")
                        completionHandler(nil)
                    }
                    
                case .failure(let error):
                    print("Request error: \(error)")
                    completionHandler(nil)
                }
            }
    }

    
    func postDataToApi(endpoint: TestEndpoint, rootOfJson: Root, body: Data, completion: @escaping (Data?, Error?) -> Void) {
        let urlString = "https://\(API_KEY):\(TOKEN)\(baseUrl)\(endpoint.rawValue)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TOKEN, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.httpBody = body

        if let requestBody = String(data: body, encoding: .utf8) {
            print("Network  -> Request Body: \(requestBody)")
        }

        AF.request(request)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Network -> Response Body: \(responseString)")
                    }
                    if let httpResponse = response.response {
                        print("Network -> Response Status Code: \(httpResponse.statusCode)")
                    }
                    completion(data, nil)
                case .failure(let error):
                    print("Network request failed with error: \(error.localizedDescription)")
                    if let httpResponse = response.response {
                        print("Network -> Response Status Code: \(httpResponse.statusCode)")
                    }
                    completion(nil, error)
                }
            }
    }
    
    func updateResource(endpoint: TestEndpoint, rootOfJson: Root, productId: String, variantId: String? = nil, body: Data, completion: @escaping (Data?, Error?) -> Void) {
        let apiKey = Secrets.apiKey
        let password = Secrets.token
        let baseUrl = "mad44-alx-ios-4.myshopify.com/admin/api/2024-01"
        
        var urlString = "https://\(baseUrl)/\(endpoint.rawValue.replacingOccurrences(of: "{productId}", with: productId).replacingOccurrences(of: "{variantId}", with: variantId ?? ""))"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(apiKey):\(password)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        
        print("\nRequest URL: \(urlString)")
        print("Request Headers:")
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            print("\(key): \(value)")
        }
        print("Request Body:")
        if let requestBodyString = String(data: body, encoding: .utf8) {
            print(requestBodyString)
        } else {
            print("Failed to convert request body to String.")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network request failed with error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response: \(response.debugDescription)")
                completion(nil, NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected response"]))
                return
            }
            
            print("\nSuccess in \(request.httpMethod ?? "PUT") request")
            print("Response Status Code: \(httpResponse.statusCode)")
            print("Response Headers:")
            if let responseHeaders = httpResponse.allHeaderFields as? [String: String] {
                for (key, value) in responseHeaders {
                    print("\(key): \(value)")
                }
            }
            print("Response Body:")
            if let data = data, let responseBodyString = String(data: data, encoding: .utf8) {
                print(responseBodyString)
                completion(data, nil)
            } else {
                print("Failed to convert response body to String.")
                completion(nil, NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey: "Empty response"]))
            }
        }.resume()
    }



    func deleteFromAPI(endpoint: ShopifyEndpoint, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let deleteURL = endpoint.url
        
        AF.request(deleteURL, method: .delete, headers: nil)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    switch endpoint {
                    case .deleteProduct:
                        print("Product deleted successfully")
                    case .deleteProductImage:
                        print("Image deleted successfully")
                    case .deletePriceRule:
                        print("Price rule deleted successfully")
                        
                    default:
                        break
                    }
                    completionHandler(.success(()))
                    
                case .failure(let error):
                    switch endpoint {
                    case .deleteProduct:
                        print("Failed to delete product: \(error)")
                    case .deleteProductImage:
                        print("Failed to delete product: \(error)")
                    case .deletePriceRule:
                        print("Failed to delete price rule: \(error)")
                    default:
                        break
                    }
                    completionHandler(.failure(error))
                }
            }
    }
}
