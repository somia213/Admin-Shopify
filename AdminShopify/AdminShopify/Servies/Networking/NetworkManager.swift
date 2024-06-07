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
}


