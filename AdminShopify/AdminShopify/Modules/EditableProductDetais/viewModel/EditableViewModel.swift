
//  EditableViewModel.swift
//  AdminShopify
//
//  Created by Somia on 11/06/2024.


import Foundation

class EditableProductDetailsViewModel {
    private let networkManager: NetworkServicing
    
    init(networkManager: NetworkServicing = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    var product: Product?
    var selectedSize: String?
    var selectedColor: String?
    var selectedImageSrc: String?
    var selectedVariantId : Int?
    
    var timer: Timer?
    var currentCellIndex = 0
    var arrProductImg: [String] = []
    var variants: [Variant] = []
    
    var newVariants: [Variant] = []
    var productIdString: String = ""

    
    func updateProductDetails(productId: String, updatedData: Data, completion: @escaping (Data?, Error?) -> Void) {
        let networkManager = NetworkManager.shared
        
        networkManager.updateResource(endpoint: .specificUpDateProduct, rootOfJson: .postProduct, productId: productId, body: updatedData) { (data, error) in
            completion(data, error)
        }
    }
    
    func updateVariantDetails(productId: String, variantId: String, updatedData: Data, completion: @escaping (Data?, Error?) -> Void) {
        let networkManager = NetworkManager.shared
        
        networkManager.updateResource(endpoint: .specificVariant, rootOfJson: .postVariant, productId: productId, variantId: variantId, body: updatedData) { (data, error) in
            completion(data, error)
        }
    }
    
    func fetchProduct(productId: Int, completionHandler: @escaping (ProductData?) -> Void) {
        let endpoint = ShopifyEndpoint.productDetails(productId: productId)
        
        print("Fetching product with endpoint: \(endpoint.url)")
        
        networkManager.fetchDataFromAPI(endpoint: endpoint) { (productResponse: AddProductRequest?) in
            guard let productData = productResponse?.product else {
                print("Failed to fetch product details.")
                completionHandler(nil)
                return
            }
            
            print("Received product response: \(productData)")
            completionHandler(productData)
        }
    }
    
    func deleteImage(imageIdToDelete: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let productId = product?.id else {
            completionHandler(.failure(NetworkError.unknownError))
            return
        }
        
        print("Deleting image with ID \(imageIdToDelete)")
        
        let endpoint = ShopifyEndpoint.deleteProductImage(productId: productId, imageId: imageIdToDelete)
        let deleteURL = endpoint.url
        print("Endpoint: \(endpoint)")
        print("Delete URL: \(deleteURL)")
        
        networkManager.deleteFromAPI(endpoint: endpoint) { result in
            switch result {
            case .success:
                print("Request to delete image with ID \(imageIdToDelete) sent successfully")
                completionHandler(.success(()))
            case .failure(let error):
                print("Failed to delete image with ID \(imageIdToDelete) from API: \(error)")
                print("Failed to delete image with URL \(endpoint) from API: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
    
    func updateVariantInventory(variantId: Int, inventoryItemId: Int, quantity: Int, completion: @escaping (Data?, Error?) -> Void) {
            let networkManager = NetworkManager.shared
            
            let endpoint = ShopifyEndpoint.setInventoryLevels(productId: variantId)
            
            let postData: [String: Any] = [
                "location_id": 76326863096,
                "inventory_item_id": inventoryItemId,
                "available": quantity
            ]
            
            guard let postDataJson = try? JSONSerialization.data(withJSONObject: postData) else {
                print("Failed to serialize inventory update data.")
                return
            }
            
            networkManager.postDataToApi(endpoint: .updateVariantInventory, rootOfJson: .postInventoryQuantity, body: postDataJson) { (data, error) in
                completion(data, error)
            }
        }
}
