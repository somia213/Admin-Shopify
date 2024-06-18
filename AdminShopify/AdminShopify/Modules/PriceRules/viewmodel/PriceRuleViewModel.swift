//
//  PriceRuleViewModel.swift
//  AdminShopify
//
//  Created by Somia on 14/06/2024.
//

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
    
    init(networkManager: NetworkServicing = NetworkManager.shared) {
        self.networkManager = networkManager
     //   startFetching()
    }
//    
//    deinit {
//        stopFetching()
//    }
//    
//    func startFetching() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            self.fetchPriceRules()
//        }
//        timer?.fire() // Immediately fetch price rules on start
//    }
//    
//    func stopFetching() {
//        timer?.invalidate()
//        timer = nil
//    }
    
    func fetchPriceRules() {
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
