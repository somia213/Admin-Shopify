//
//  addProduct.swift
//  AdminShopify
//
//  Created by Somia on 08/06/2024.
//

import Foundation

enum NetworkError: Error {
    case failedToAddProduct
    case unknownError
}

class AddProductViewModel {
    let networkManager: NetworkServicing
    
    init(networkManager: NetworkServicing) {
        self.networkManager = networkManager
    }
    
    func addProduct(product: AddProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
            networkManager.addProductToAPI(endpoint: ShopifyEndpoint.addProduct, product: product) { result in
                completionHandler(result)
            }
        }
}

