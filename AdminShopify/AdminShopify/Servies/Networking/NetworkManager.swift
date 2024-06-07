//
//  NetworkManager.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import Foundation
import Alamofire


protocol NetworkServicing {
    func fetchDataFromAPI<T: Decodable>(url: String, completionHandler: @escaping (T?) -> Void)
}

class NetworkManager: NetworkServicing {
    func fetchDataFromAPI<T>(url: String, completionHandler: @escaping (T?) -> Void) where T: Decodable {
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response { resp in
                switch resp.result {
                case .success(let data):
                    guard let data = data else {
                        print("No data received from the server.")
                        completionHandler(nil)
                        return
                    }
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
