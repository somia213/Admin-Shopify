//
//  AddNewPriceRuleViewController.swift
//  AdminShopify
//
//  Created by Somia on 06/06/2024.
//

import UIKit

class AddNewPriceRuleViewController: UIViewController ,AddNewProductView {

    @IBOutlet weak var priceRuleTotle: UITextField!
    @IBOutlet weak var priceRuleType: UISegmentedControl!
    @IBOutlet weak var discountAmount: UITextField!
    @IBOutlet weak var UsageLimit: UITextField!
    
    @IBOutlet weak var startDate: UIDatePicker!
    
    @IBOutlet weak var endDate: UIDatePicker!
    var presenter: AddNewProductPresenter!
    
    var model: AddPriceRuleViewModel!
    
    var priceRulesViewModel: PriceRulesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)
        model = AddPriceRuleViewModel(networkManager: NetworkManager.shared)
        priceRulesViewModel = PriceRulesViewModel()

    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        guard let title = priceRuleTotle.text, !title.isEmpty else {
            showAlert(message: "Please enter a title.")
            return
        }

        let valueType: String
        if priceRuleType.selectedSegmentIndex == 1 {
            valueType = "fixed_amount"
        } else {
            valueType = "percentage"
        }

        guard let valueText = discountAmount.text, !valueText.isEmpty, let value = Double(valueText) else {
            showAlert(message: "Please enter a valid discount amount.")
            return
        }

        if valueType == "percentage" {
            if !(value < 0 && value >= -100) {
                showAlert(message: "Please enter a discount amount between -100 and 0 for percentage type.")
                return
            }
        } else if valueType == "fixed_amount" {
            if !(value < 0) {
                showAlert(message: "Please enter a discount amount by negative value.")
                return
            }
            
        }

        guard let usageLimitText = UsageLimit.text, let usageLimit = Int(usageLimitText) else {
            showAlert(message: "Please enter a valid usage limit.")
            return
        }

            let startsAt = startDate.date
            let endsAt = endDate.date

            model.addPriceRule(title: title,
                               valueType: valueType,
                               value: String(value),
                               customerSelection: "all",
                               startsAt: startsAt,
                               endsAt: endsAt,
                               usageLimit: usageLimit) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        if let priceRulesVC = self?.presentingViewController as? PriceRulesViewController {
                            priceRulesVC.viewModel.fetchPriceRules()
                        }
                        self?.navigateBack()
                    case .failure(let error):
                        self?.showAlert(message: error.localizedDescription)
                    }
                }
            }
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
