//
////  EditableViewModel.swift
////  AdminShopify
////
////  Created by Somia on 11/06/2024.
//
//
//import Foundation
//
//class EditableProductDetailsViewModel {
//    var product: Product?
//    var selectedSize: String?
//    var selectedColor: String?
//    var selectedImageSrc: String?
//    
//    func updatePriceAndQuantity() -> (price: String?, quantity: String?) {
//        guard let product = product, let selectedSize = selectedSize else {
//            return (nil, nil)
//        }
//        
//        if let variant = product.variants.first(where: { $0.option1 == selectedSize }) {
//            let price = variant.price
//            let quantity = "\(variant.inventory_quantity)"
//            return (price, quantity)
//        }
//        
//        return (nil, nil)
//    }
//       
//       func updateTitle(newTitle: String) {
//           product?.title = newTitle
//       }
//       
//       func updateBodyHTML(newBodyHTML: String) {
//           product?.body_html = newBodyHTML
//       }
//       
//       
//       func updatePriceAndQuantity(newPrice: String, newQuantity: Int) {
//           guard let selectedSize = selectedSize else {
//               return
//           }
//           
//           if let variantIndex = product?.variants.firstIndex(where: { $0.option1 == selectedSize }) {
//               product?.variants[variantIndex].price = newPrice
//               product?.variants[variantIndex].inventory_quantity = newQuantity
//           }
//       }
//       
//   
//    func updateSize(newSize: String) {
//        guard let selectedSize = selectedSize else {
//            return
//        }
//        
//        if let variantIndex = product?.variants.firstIndex(where: { $0.option1 == selectedSize }) {
//            product?.variants[variantIndex].option1 = newSize
//        }
//    }
//    
//    func updateColor(newColor: String) {
//        guard let selectedSize = selectedSize, let selectedColor = selectedColor else {
//            return
//        }
//
//        if let variant = product?.variants.firstIndex(where: { $0.option1 == selectedSize && $0.option2 == selectedColor }) {
//            product?.variants[variant].option2 = newColor
//        }
//    }
//
//
//        func updateImageSrc(newImageSrc: String) {
//            selectedImageSrc = newImageSrc
//        }
//    
//    
//    func updateTitleInAPI(newTitle: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
//        guard let productId = product?.id, let currentBodyHTML = product?.body_html, let currentImages = product?.images else {
//            completionHandler(.failure(NetworkError.unknownError))
//            return
//        }
//
//        print("Product ID: \(productId)")
//
//        let updatedProduct = UpdatedProductRequest(product: UpdateProduct(title: newTitle, body_html: currentBodyHTML, images: currentImages))
//        NetworkManager.shared.updateProductInAPI(endpoint: ShopifyEndpoint.updateProduct(productId: productId), productId: productId, updatedProduct: updatedProduct) { result in
//            switch result {
//            case .success:
//                completionHandler(.success(true))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//    }
//
//    func updateDescriptionInAPI(newDescription: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
//        guard let productId = product?.id, let currentTitle = product?.title, let currentImages = product?.images else {
//            completionHandler(.failure(NetworkError.unknownError))
//            return
//        }
//
//        print("Product ID: \(productId)")
//
//        let updatedProduct = UpdatedProductRequest(product: UpdateProduct(title: currentTitle, body_html: newDescription, images: currentImages))
//        NetworkManager.shared.updateProductInAPI(endpoint: ShopifyEndpoint.updateProduct(productId: productId), productId: productId, updatedProduct: updatedProduct) { result in
//            switch result {
//            case .success:
//                completionHandler(.success(true))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//    }
//
//    
//
//    func addImageWithURL(_ imageUrl: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
//        guard var product = product else {
//            completionHandler(.failure(NetworkError.unknownError))
//            return
//        }
//        
//        let currentTitle = product.title
//        let currentBodyHTML = product.body_html
//        
//        let newImage = UpdateProductImage(src: imageUrl)
//        product.images.append(newImage)
//        
//        let updatedProductData = UpdateProduct(title: currentTitle, body_html: currentBodyHTML, images: product.images)
//        let updatedProduct = UpdatedProductRequest(product: updatedProductData)
//
//        let productId = product.id
//        
//        NetworkManager.shared.updateProductInAPI(endpoint: ShopifyEndpoint.updateProduct(productId: productId), productId: productId, updatedProduct: updatedProduct) { result in
//            switch result {
//            case .success:
//                completionHandler(.success(true))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//        print("Product ID: \(productId)")
//    }
//
//}
//
