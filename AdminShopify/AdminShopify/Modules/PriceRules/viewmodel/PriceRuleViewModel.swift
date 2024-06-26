//
//  PriceRuleViewModel.swift
//  AdminShopify
//
//  Created by Somia on 14/06/2024.
//

import Foundation

class PriceRulesViewModel {
    
    private let networkManager: NetworkServicing
    var priceRules: [GetPriceRule] = []
    private var timer: Timer?
    
    var dataUpdated: (() -> Void)?
    var noInternetConnection: (() -> Void)?
    
    init(networkManager: NetworkServicing = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchPriceRules() {
        guard Connectivity.connectivityInstance.isConnectedToInternet() else {
            print("No internet connection.")
            noInternetConnection?()
            return
        }
        
        networkManager.fetchDataFromAPI(endpoint: ShopifyEndpoint.getAllpriceRules) { [weak self] (response: PriceRulesResponse?) in
            guard let self = self else { return }
            if let response = response {
                self.priceRules = response.price_rules
                self.dataUpdated?()
            } else {
                print("Error: Unable to fetch price rules.")
            }
        }
    }
    
    func numberOfPriceRules() -> Int {
        return priceRules.count
    }
    
    func deletePriceRule(priceRuleId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        networkManager.deleteFromAPI(endpoint: ShopifyEndpoint.deletePriceRule(priceRuleId: priceRuleId)) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                print("Failed to delete price rule: \(error)")
                completion(.failure(error))
            }
        }
    }
}
