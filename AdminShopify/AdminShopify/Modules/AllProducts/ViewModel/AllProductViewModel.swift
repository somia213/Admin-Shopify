//
//  AllProductViewModel.swift
//  AdminShopify
//
//  Created by Somia on 10/06/2024.
//

import Foundation

class ProductsViewModel {
    let networkManager: NetworkServicing
    var products: [AllProduct] = []
    var filteredProducts: [AllProduct] = []
    
    init(networkManager: NetworkServicing) {
        self.networkManager = networkManager
    }
    
    func getAllProducts(completionHandler: @escaping (Bool) -> Void) {
        let endpoint = ShopifyEndpoint.allProducts
        
        networkManager.fetchDataFromAPI(endpoint: endpoint) { [weak self] (response: AllProductResponse?) in
            guard let self = self else { return }
            if let response = response {
                self.products = response.products
                self.filteredProducts = response.products // Initialize filtered products
                completionHandler(true)
            } else {
                print("Failed to fetch products.")
                completionHandler(false)
            }
        }
    }
    
    func filterProducts(searchText: String) {
        print("Search text: \(searchText)")
        if searchText.isEmpty {
            filteredProducts = products
        } else {
            let lowercasedSearchText = searchText.lowercased()
            filteredProducts = products.filter { $0.title.lowercased().contains(lowercasedSearchText) }
        }
        print("Filtered products count: \(filteredProducts.count)")
    }

}
