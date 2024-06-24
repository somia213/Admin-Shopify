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
    
    func testPostDataToApi() throws {
        let expectation = self.expectation(description: "Post data to API")
        
        let endpoint = TestEndpoint.specificPriceRule
        let root = Root.postPriceRule
        
        let priceRule = GetPriceRule(
            id: 0,
            value_type: "percentage",
            value: "10.0",
            customer_selection: "all",
            target_type: "line_item",
            target_selection: "all",
            allocation_method: "across",
            allocation_limit: nil,
            once_per_customer: false,
            usage_limit: 1,
            starts_at: "2024-06-24T00:00:00Z",
            ends_at: "2024-06-30T00:00:00Z",
            created_at: "",
            updated_at: "",
            title: "Test Price Rule",
            admin_graphql_api_id: ""
        )
        
        let priceRuleDict: [String: Any] = [
                "price_rule": [
                "title": priceRule.title,
                "target_type": priceRule.target_type,
                "target_selection": priceRule.target_selection,
                "allocation_method": priceRule.allocation_method,
                "value_type": priceRule.value_type,
                "value": priceRule.value,
                "customer_selection": priceRule.customer_selection,
                "starts_at": priceRule.starts_at,
                "ends_at": priceRule.ends_at,
                "once_per_customer": priceRule.once_per_customer,
                "usage_limit": priceRule.usage_limit
            ]
        ]
        
        let body = try JSONSerialization.data(withJSONObject: priceRuleDict, options: [])
        
        networkManager.postDataToApi(endpoint: endpoint, rootOfJson: root, body: body) { data, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                XCTAssertNotNil(data, "Data should not be nil")
                
                if let data = data {
                    do {
                        let responseString = String(data: data, encoding: .utf8)
                        print("Response Body: \(responseString ?? "No response body")")
                        
                        let response = try JSONDecoder().decode(PriceRulesResponse.self, from: data)
                        XCTAssertNotNil(response.price_rules, "Price rules response should not be nil")
                        XCTAssertFalse(response.price_rules.isEmpty, "Price rules should not be empty")
                    } catch {
                        XCTFail("Decoding error: \(error)")
                    }
                }
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testDeleteProductFromAPI() throws {
            let expectation = self.expectation(description: "Delete product from API")
            
            let productIdToDelete = "8604100067576"  
            
            let endpoint = ShopifyEndpoint.deleteProduct(productId: Int(productIdToDelete)!)
            
            networkManager.deleteFromAPI(endpoint: endpoint) { result in
                switch result {
                case .success:
                    print("Product deleted successfully")
                    XCTAssertTrue(true, "Product deletion succeeded")
                case .failure(let error):
                    XCTFail("Product deletion failed with error: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10.0, handler: nil)
        }
    
    func testUpdateResource() {
            let endpoint = TestEndpoint.specificUpDateProduct
            let root = Root.postProduct
            let productId = "8606359224568"
            let variantId = "45371146502392"
            let product = AddProductRequest(
                product: ProductData(
                    title: "Test Product",
                    body_html: "<p>This is a test product</p>",
                    vendor: "Test Vendor",
                    variants: [
                        VariantRequest(
                            title: "Test Variant",
                            price: "9.99",
                            option1: "Option 1",
                            option2: "Option 2",
                            inventory_quantity: 10,
                            old_inventory_quantity: 5,
                            sku: "TESTSKU"
                        )
                    ],
                    options: [
                        OptionRequest(name: "Size", values: ["Small", "Medium", "Large"])
                    ],
                    images: [
                        ImageRequest(id: nil, src: "https://cdn.shopify.com/s/files/1/0703/6328/3704/files/8072c8b5718306d4be25aac21836ce16_ea4d7456-c869-4bf2-b3ec-a2635eef6818.jpg?v=1719190563")
                    ]
                )
            )
            
            let bodyData: Data
            do {
                bodyData = try JSONEncoder().encode(product)
            } catch {
                XCTFail("Failed to encode request body: \(error)")
                return
            }
            
            let expectation = self.expectation(description: "Network Request")
            
            
        networkManager.updateResource(endpoint: endpoint, rootOfJson: root, productId: productId, variantId: variantId, body: bodyData) { data, error in
                if let error = error {
                    XCTFail("Network request failed with error: \(error)")
                } else {
                    XCTAssertNotNil(data, "Expected non-nil data")
                    if let data = data {
                        print("Response Data: \(String(data: data, encoding: .utf8) ?? "N/A")")
                    }
                }
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
        }
}
