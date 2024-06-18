//
//  addProduct.swift
//  AdminShopify
//
//  Created by Somia on 08/06/2024.
//

import Foundation

struct TestAddProductResponse: Codable {
    let success: Bool
}
class AddProductViewModel {
    
    var variants: [VariantRequest] = []
       var images: [String] = []
    let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func addVariant(variant: VariantRequest) {
            variants.append(variant)
        }

        func addImage(src: String) {
            images.append(src)
        }

    func addProduct(product: AddProductRequest, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
            do {
                let encoder = JSONEncoder()
                let body = try encoder.encode(product)

                networkManager.postDataToApi(endpoint: .specificProduct, rootOfJson: .postProduct, body: body) { data, error in
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        if let responseData = data {
                            do {
                                let decoder = JSONDecoder()
                                let response = try decoder.decode(TestAddProductResponse.self, from: responseData)
                                completionHandler(.success(response.success))
                            } catch {
                                completionHandler(.failure(error))
                            }
                        } else {
                            completionHandler(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data in response"])))
                        }
                    }
                }
            } catch {
                completionHandler(.failure(error))
            }
        }
    
    
    func constructProduct(title: String?, description: String?, vendor: String?, variants: [VariantRequest], images: [String]) -> AddProductRequest? {
            guard let title = title, !title.isEmpty,
                  let vendor = vendor, !vendor.isEmpty,
                  let description = description, !description.isEmpty,
                  !variants.isEmpty, !images.isEmpty else {
                return nil
            }

            var uniqueSizes = Set<String>()
            var uniqueColors = Set<String>()
            var variantsData: [VariantRequest] = []

            for variant in variants {
                let variantTitle = "\(variant.option1) / \(variant.option2)"
                let sku = "AD-03-\(variant.option2.lowercased())-\(variant.option1.lowercased())"

                if uniqueSizes.contains(variant.option1) && uniqueColors.contains(variant.option2) {
                    continue
                }

                uniqueSizes.insert(variant.option1)
                uniqueColors.insert(variant.option2)

                let variantData = VariantRequest(
                    title: variantTitle,
                    price: variant.price,
                    option1: variant.option1,
                    option2: variant.option2,
                    inventory_quantity: variant.inventory_quantity,
                    old_inventory_quantity: variant.old_inventory_quantity,
                    sku: sku
                )
                variantsData.append(variantData)
            }

            let sizesOption = OptionRequest(name: "Size", values: Array(uniqueSizes))
            let colorsOption = OptionRequest(name: "Color", values: Array(uniqueColors))

            let optionsArray = [sizesOption, colorsOption]

            let imagesArray = images.map { ImageRequest(src: $0) }

            let product = ProductData(
                title: title,
                body_html: description,
                vendor: vendor,
                variants: variantsData,
                options: optionsArray,
                images: imagesArray
            )

            let addProductRequest = AddProductRequest(product: product)
            return addProductRequest
        }
    
    }

