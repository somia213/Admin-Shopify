//
//  addProduct.swift
//  AdminShopify
//
//  Created by Somia on 08/06/2024.
//

import Foundation

class AddProductViewModel {
    let networkManager: NetworkServicing
    
    init(networkManager: NetworkServicing) {
        self.networkManager = networkManager
    }
    
    func addProduct(product: ProductData, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        let addProductRequest = AddProductRequest(product: product)
        networkManager.addProductToAPI(endpoint: ShopifyEndpoint.addProduct, product: addProductRequest) { result in
            completionHandler(result)
        }
    }
}

