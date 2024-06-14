//
//  addProduct.swift
//  AdminShopify
//
//  Created by Somia on 08/06/2024.
//

import Foundation

struct TestAddProductResponse: Codable {
    let success: Bool
}
class AddProductViewModel {
    let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func addProduct(product: ProductData, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
            do {
                let encoder = JSONEncoder()
                let productRequest = AddProductRequest(product: product)
                let body = try encoder.encode(productRequest)
                
                networkManager.postDataToApi(endpoint: .specificProduct, rootOfJson: .postProduct, body: body) { data, error in
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        if let responseData = data {
                            do {
                                let decoder = JSONDecoder()
                                let response = try decoder.decode(TestAddProductResponse.self, from: responseData)
                                completionHandler(.success(response.success))
                            } catch {
                                completionHandler(.failure(error))
                            }
                        } else {
                            completionHandler(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data in response"])))
                        }
                    }
                }
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

