//
//  AddNewPriceRuleViewController.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import UIKit

class AddNewPriceRuleViewController: UIViewController ,AddNewProductView {

    @IBOutlet weak var priceRuleTotle: UITextField!
    @IBOutlet weak var startdate: UITableView!
    @IBOutlet weak var endDate: UITableView!
    @IBOutlet weak var priceRuleType: UISegmentedControl!
    @IBOutlet weak var discountAmount: UITextField!
    @IBOutlet weak var minimumSubtotal: UITextField!
    @IBOutlet weak var UsageLimit: UITextField!
    
    var presenter: AddNewProductPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)

    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    
    @IBAction func doneBtn(_ sender: Any) {
    }
    
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
}
