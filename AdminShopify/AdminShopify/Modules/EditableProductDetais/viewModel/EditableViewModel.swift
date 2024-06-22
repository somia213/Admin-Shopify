
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
    
    
    
    
    func updatePriceAndQuantity() -> (price: String?, quantity: String?) {
        guard let product = product, let selectedSize = selectedSize else {
            return (nil, nil)
        }
        
        if let variant = product.variants.first(where: { $0.option1 == selectedSize }) {
            let price = variant.price
            let quantity = "\(variant.inventory_quantity)"
            return (price, quantity)
        }
        
        return (nil, nil)
    }
    
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
    
    
    typealias ProductCompletionHandler = (Product?) -> Void
    
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
    
    func deleteImageAtIndex(_ index: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        guard let productId = product?.id, index < arrProductImg.count else {
            print("Invalid index or product ID.")
            return
        }
        
        let endpoint = ShopifyEndpoint.deleteProductImage(productId: productId, imageId: index + 1)
        
        print("Deleting image with endpoint: \(endpoint.url)")
        
        networkManager.deleteFromAPI(endpoint: endpoint) { result in
            switch result {
            case .success:
                self.arrProductImg.remove(at: index)
                print("Image deleted successfully.")
                completionHandler(.success(()))
                
            case .failure(let error):
                print("Failed to delete image: \(error)")
                completionHandler(.failure(error))
            }
        }
    }
    
    func deleteImageFromShopify(with endpoint: String) {
        guard let url = URL(string: endpoint) else {
            print("Invalid endpoint URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let apiKey = "your_api_key"
        let apiPassword = "your_api_password"
        let basicAuthString = "\(apiKey):\(apiPassword)"
        let base64Auth = basicAuthString.data(using: .utf8)?.base64EncodedString() ?? ""
        request.setValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error deleting image: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Invalid response.")
                return
            }
            
            DispatchQueue.main.async {
                if response.statusCode == 200 {
                    print("Image deleted successfully.")
                } else {
                    print("Failed to delete image. Status code: \(response.statusCode)")
                }
            }
        }.resume()
    }

}
