//
//  BrandProductViewModel.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//


import Foundation

//class BrandProductViewModel {
//    private let networkManager: NetworkServicing
//    private var products: [Product] = []
//
//    var dataUpdated: (() -> Void)?
//
//    init(networkManager: NetworkServicing = NetworkManager()) {
//        self.networkManager = networkManager
//        fetchData()
//    }
//    
//    func fetchData() {
//        networkManager.fetchDataFromAPI(endpoint: ShopifyEndpoint.addProduct) { [weak self] (response: BrandProductResponse?) in
//            guard let self = self else { return }
//            if let response = response {
//                self.products = response.products
//                print("================================ /( response.products)")
//                self.dataUpdated?()
//            } else {
//                print("Failed to fetch products.")
//            }
//        }
//    }
//
//    func numberOfProducts() -> Int {
//        return products.count
//    }
//
//    func product(at index: Int) -> Product {
//        return products[index]
//    }
//}

class BrandProductViewModel {
    private let networkManager: NetworkServicing
    private var products: [Product] = []

    var dataUpdated: (() -> Void)?

    init(networkManager: NetworkServicing = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchData() {
        networkManager.fetchDataFromAPI(endpoint: ShopifyEndpoint.addProduct) { [weak self] (response: BrandProductResponse?) in
            guard let self = self else { return }
            if let response = response {
                self.products = response.products
                self.dataUpdated?()
            } else {
                print("Failed to fetch products.")
            }
        }
    }

    func numberOfProducts() -> Int {
        return products.count
    }

    func products(forVendor vendor: String) -> [Product] {
        return products.filter { $0.vendor == vendor }
    }
}
