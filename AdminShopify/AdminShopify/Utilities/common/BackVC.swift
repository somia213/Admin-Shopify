//
//  BackVC.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import Foundation

protocol AddNewProductView: AnyObject {
    func navigateBack()
}

class AddNewProductPresenter {
    
    weak var view: AddNewProductView?
    
    init(view: AddNewProductView) {
        self.view = view
    }
    
    func goBack() {
        view?.navigateBack()
    }
}
