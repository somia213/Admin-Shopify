//
//  NetworkManager.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case failedToAddProduct
    case unknownError
}

protocol NetworkServicing {
    func fetchDataFromAPI<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (T?) -> Void)
    func addProductToAPI(endpoint: Endpoint, product: AddProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void)
   // func fetchProductDetails<T: Decodable>(productId: Int, completionHandler: @escaping (T?) -> Void)
}

class NetworkManager: NetworkServicing {
        
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
    
    
    
    func addProductToAPI(endpoint: Endpoint, product: AddProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        guard let requestData = try? JSONEncoder().encode(product) else {
            print("Failed to encode product data.")
            completionHandler(.failure(NetworkError.failedToAddProduct))
            return
        }
        
        if let jsonString = String(data: requestData, encoding: .utf8) {
            print("JSON data being sent to API:")
            print(jsonString)
        } else {
            print("Failed to convert JSON data to string.")
        }
        
        guard let url = URL(string: endpoint.url) else {
            print("Invalid URL: \(endpoint.url)")
            completionHandler(.failure(NetworkError.unknownError))
            return
        }
        
        print("Request URL: \(url)")
        
        let headers = ["Content-Type": "application/json"]
        print("Request Headers: \(headers)")
        
        print("Request Payload: \(String(data: requestData, encoding: .utf8) ?? "")")
        
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = requestData
        
        AF.request(urlRequest).response { response in
            if let error = response.error {
                print("Request failed with error: \(error.localizedDescription)")
                completionHandler(.failure(error))
                return
            }
            
            if let statusCode = response.response?.statusCode {
                print("HTTP response status code: \(statusCode)")
                
                if 200 ..< 300 ~= statusCode {
                    print("Product added successfully.")
                    completionHandler(.success(true))
                } else {
                    print("Failed to add product. Status code: \(statusCode)")
                    completionHandler(.failure(NetworkError.failedToAddProduct))
                }
            }
            
            if let responseData = response.data {
                print("Response from Shopify API:")
                print(String(data: responseData, encoding: .utf8) ?? "Unable to print response data.")
            }
        }
    }
    
//    func fetchProductDetails<T>(productId: Int, completionHandler: @escaping (T?) -> Void) where T: Decodable {
//        print("Fetching product details from API...")
//        
//        let endpoint = ShopifyEndpoint.productDetails(productId: productId)
//        fetchDataFromAPI(endpoint: endpoint) { (response: T?) in
//            if let response = response {
//                print("Response received from API of product details is:", response)
//            } else {
//                print("Response is nil")
//            }
//            
//            completionHandler(response)
//        }
//    }

}
