//
//  BrandProductViewModel.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//


import Foundation

class BrandProductViewModel {
    private let networkManager: NetworkServicing
    var products: [Product] = []

    var dataUpdated: (() -> Void)?

    init(networkManager: NetworkServicing = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchData(forBrand brand: String) {
        networkManager.fetchDataFromAPI(endpoint: ShopifyEndpoint.productsByBrand(brand: brand)) { [weak self] (response: BrandProductResponse?) in
            guard let self = self else { return }
            if let response = response {
                self.products = response.products
                print("================================ \(response.products)")
                self.dataUpdated?()
            } else {
                print("Failed to fetch products.")
            }
        }
    }

    func numberOfProducts() -> Int {
        return products.count
    }

    func deleteProduct(productId: Int, completion: @escaping (Bool) -> Void) {
        networkManager.deleteFromAPI(endpoint: ShopifyEndpoint.deleteProduct(productId: productId)) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                print("Failed to delete product: \(error)")
                completion(false)
            }
        }
    }
}
