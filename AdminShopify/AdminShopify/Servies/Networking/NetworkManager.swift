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
    
}

enum TestEndpoint: String {
    case specificProduct = "products.json"
    case specificPriceRule = "price_rules.json"
    case specificDiscountOrder = "price_rules/{priceRuleId}/discount_codes.json"
    
    var endpointString: String {
        switch self {
        case .specificProduct, .specificPriceRule:
            return self.rawValue
        case .specificDiscountOrder:
            return self.rawValue
        }
    }
}


enum NetworkError: Error {
    case failedToAddProduct
    case unknownError
}


protocol NetworkServicing {
    
    func fetchDataFromAPI<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (T?) -> Void)
   // func addProductToAPI(endpoint: Endpoint, product: AddProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void)
  //  func updateProductInAPI(endpoint: Endpoint, productId: Int, updatedProduct: UpdatedProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void)
    
    func postDataToApi(endpoint: TestEndpoint, rootOfJson: Root, body: Data, completion: @escaping (Data?, Error?) -> Void)
    func deleteFromAPI(endpoint: ShopifyEndpoint, completionHandler: @escaping (Result<Void, Error>) -> Void)
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
        
     /*
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
        
        if let requestBody = String(data: body, encoding: .utf8) {
            print("Request Body: \(requestBody)")
        }
        
        request.httpBody = body
        AF.request(request)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response Body: \(jsonString)")
                    }
                    print("Success in post")
                    completion(data, nil)
                case .failure(let error):
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("Response Body: \(jsonString)")
                    }
                    print("Network request failed with error: \(error)")
                    completion(nil, error)
                }
            }
    }
    
*/
    
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
                    case .deletePriceRule:
                        print("Failed to delete price rule: \(error)")
                    default:
                        break
                    }
                    completionHandler(.failure(error))
                }
            }
    }


//        func addProductToAPI(endpoint: Endpoint, product: AddProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
//            guard let requestData = try? JSONEncoder().encode(product) else {
//                print("Failed to encode product data.")
//                completionHandler(.failure(NetworkError.failedToAddProduct))
//                return
//            }
//            
//            if let jsonString = String(data: requestData, encoding: .utf8) {
//                print("JSON data being sent to API:")
//                print(jsonString)
//            } else {
//                print("Failed to convert JSON data to string.")
//            }
//            
//            guard let url = URL(string: endpoint.url) else {
//                print("Invalid URL: \(endpoint.url)")
//                completionHandler(.failure(NetworkError.unknownError))
//                return
//            }
//            
//            print("Request URL: \(url)")
//            
////            let headers = ["Content-Type": "application/json"]
////            print("Request Headers: \(headers)")
////            
////            print("Request Payload: \(String(data: requestData, encoding: .utf8) ?? "")")
//            
//            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//            var urlRequest = URLRequest(url: url)
//            urlRequest.httpMethod = HTTPMethod.post.rawValue
//        //    urlRequest.allHTTPHeaderFields = headers
//            urlRequest.httpBody = requestData
//            
//            AF.request(urlRequest).response { response in
//                if let error = response.error {
//                    print("Request failed with error: \(error.localizedDescription)")
//                    completionHandler(.failure(error))
//                    return
//                }
//                
//                if let statusCode = response.response?.statusCode {
//                    print("HTTP response status code: \(statusCode)")
//                    
//                    if 200 ..< 300 ~= statusCode {
//                        print("Product added successfully.")
//                        completionHandler(.success(true))
//                    } else {
//                        print("Failed to add product. Status code: \(statusCode)")
//                        completionHandler(.failure(NetworkError.failedToAddProduct))
//                    }
//                }
//                
//                if let responseData = response.data {
//                    print("Response from Shopify API:")
//                    print(String(data: responseData, encoding: .utf8) ?? "Unable to print response data.")
//                }
//            }
//        }
        
        
//        func updateProductInAPI(endpoint: Endpoint, productId: Int, updatedProduct: UpdatedProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
//            guard let requestData = try? JSONEncoder().encode(updatedProduct) else {
//                print("Failed to encode updated product data.")
//                completionHandler(.failure(NetworkError.unknownError))
//                return
//            }
//            
//            if let jsonString = String(data: requestData, encoding: .utf8) {
//                print("Request Body:")
//                print(jsonString)
//            } else {
//                print("Failed to convert JSON data to string.")
//            }
//            
//            guard let url = URL(string: endpoint.url) else {
//                print("Invalid URL: \(endpoint.url)")
//                completionHandler(.failure(NetworkError.unknownError))
//                return
//            }
//            
//            let updatedURL = "\(url.absoluteString)/\(productId)"
//            var urlRequest = URLRequest(url: URL(string: updatedURL)!)
//            urlRequest.httpMethod = HTTPMethod.put.rawValue
//            urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
//            urlRequest.httpBody = requestData
//            
//            AF.request(urlRequest).response { response in
//                if let error = response.error {
//                    print("Request failed with error: \(error.localizedDescription)")
//                    completionHandler(.failure(error))
//                    return
//                }
//                
//                if let statusCode = response.response?.statusCode {
//                    print("HTTP response status code: \(statusCode)")
//                    
//                    if 200 ..< 300 ~= statusCode {
//                        print("Product updated successfully.")
//                        completionHandler(.success(true))
//                    } else {
//                        print("Failed to update product. Status code: \(statusCode)")
//                        completionHandler(.failure(NetworkError.unknownError))
//                    }
//                }
//                
//                if let responseData = response.data {
//                    print("Response from Shopify API:")
//                    print(String(data: responseData, encoding: .utf8) ?? "Unable to print response data.")
//                }
//            }
//        }
    }
