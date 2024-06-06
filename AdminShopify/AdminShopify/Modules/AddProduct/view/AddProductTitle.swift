//
//  AddNewProductViewController.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import UIKit

class AddNewProductViewController: UIViewController, AddNewProductView {

    @IBOutlet weak var addProductTitle: UITextField!
    @IBOutlet weak var addProductType: UITextField!
    @IBOutlet weak var addProductPrice: UITextField!
    @IBOutlet weak var addProductColor: UITextField!
    @IBOutlet weak var addProductSize: UITextField!
    @IBOutlet weak var addProductImageURL: UITextField!
    @IBOutlet weak var addProductDescription: UITextField!
    @IBOutlet weak var addProductBrand: UITextField!
    
    var presenter: AddNewProductPresenter!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
            presenter.goBack()
        }
    
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }

}
