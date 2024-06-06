//
//  AddNewVarientViewController.swift
//  AdminShopify
//
//  Created by Somia on 07/06/2024.
//

import UIKit

class AddNewVarientViewController: UIViewController , AddNewProductView {

    @IBOutlet weak var AddNewVarientViewSize: UITextField!
    
    @IBOutlet weak var AddNewVarientBrand: UITextField!
    
    @IBOutlet weak var AddNewVarientType: UITextField!
    
    @IBOutlet weak var AddNewVarientPrice: UITextField!
    var presenter: AddNewProductPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)

    }
    
    @IBAction func doneBtn(_ sender: Any) {
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
}
