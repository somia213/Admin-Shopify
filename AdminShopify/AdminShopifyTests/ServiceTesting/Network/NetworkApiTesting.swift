//
//  NetworkApiTesting.swift
//  AdminShopifyTests
//
//  Created by Somia on 24/06/2024.
//

import XCTest
@testable import AdminShopify

class NetworkApiTesting: XCTestCase {
    
    var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        networkManager = NetworkManager.shared
    }
    
    override func tearDownWithError() throws {
        networkManager = nil
    }
    
    func testFetchDataFromAPI() throws {
        let expectation = self.expectation(description: "Fetch data from API")
        
        let endpoint = ShopifyEndpoint.getAllpriceRules
        
        networkManager.fetchDataFromAPI(endpoint: endpoint) { (response: PriceRulesResponse?) in
            XCTAssertNotNil(response, "Response should not be nil")
            if let response = response {
                XCTAssertFalse(response.price_rules.isEmpty, "Price rules should not be empty")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
