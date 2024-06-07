//
//  BrandViewModel.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//

class BrandViewModel {
    private let networkManager: NetworkServicing
    private var smartCollections: [SmartCollection] = []

    var dataUpdated: (() -> Void)?
    var noInternetConnection: (() -> Void)?

    init(networkManager: NetworkServicing = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchData() {
        guard Connectivity.connectivityInstance.isConnectedToInternet() else {
            print("No internet connection.")
            noInternetConnection?()
            return
        }

        networkManager.fetchDataFromAPI(endpoint: ShopifyEndpoint.smartCollections) { [weak self] (response: SmartCollectionsResponse?) in
            guard let self = self else { return }
            if let response = response {
                self.smartCollections = response.smart_collections
                self.dataUpdated?()
            } else {
                print("Failed to fetch smart collections.")
            }
        }
    }

    func numberOfCollections() -> Int {
        return smartCollections.count
    }

    func collection(at index: Int) -> SmartCollection {
        return smartCollections[index]
    }
}
