//
//  ProductsViewModel.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

import Foundation

class ProductsViewModel {

    let networkManager: NetworkServicing
    var products: [AllProduct] = []
    var filteredProducts: [AllProduct] = []

    var noInternetConnection: (() -> Void)?

    init(networkManager: NetworkServicing) {
        self.networkManager = networkManager
    }

    func getAllProducts(completionHandler: @escaping (Bool) -> Void) {
        guard Connectivity.connectivityInstance.isConnectedToInternet() else {
            print("No internet connection.")
            noInternetConnection?()
            completionHandler(false)
            return
        }

        let endpoint = ShopifyEndpoint.allProducts
        networkManager.fetchDataFromAPI(endpoint: endpoint) { [weak self] (response: AllProductResponse?) in
            guard let self = self else { return }
            
            if let response = response {
                self.products = response.products
                self.filteredProducts = response.products
                print("Fetched products. Count: \(self.products.count)")
                completionHandler(true)
            } else {
                print("Failed to fetch products.")
                completionHandler(false)
            }
        }
    }

    func filterProducts(searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            let lowercasedSearchText = searchText.lowercased()
            filteredProducts = products.filter { $0.title.lowercased().contains(lowercasedSearchText) }
        }
        print("Filtered products count: \(filteredProducts.count)")
    }
}
