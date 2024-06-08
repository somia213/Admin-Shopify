//
//  NetworkManager.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import Foundation
import Alamofire


protocol NetworkServicing {
    func fetchDataFromAPI<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (T?) -> Void)
    func addProductToAPI(endpoint: Endpoint, product: AddProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void)

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
            
            guard let url = URL(string: endpoint.url) else {
                print("Invalid URL: \(endpoint.url)")
                completionHandler(.failure(NetworkError.unknownError))
                return
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = requestData

            AF.request(urlRequest).response { response in
                if let error = response.error {
                    print("Request failed with error: \(error.localizedDescription)")
                    completionHandler(.failure(error))
                    return
                }
                
                if let statusCode = response.response?.statusCode, 200 ..< 300 ~= statusCode {
                    completionHandler(.success(true))
                } else {
                    print("Request failed with status code: \(response.response?.statusCode ?? -1)")
                    completionHandler(.failure(NetworkError.failedToAddProduct))
                }
            }
        }
    }
