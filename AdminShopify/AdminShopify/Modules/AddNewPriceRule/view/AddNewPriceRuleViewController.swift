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
    
    @IBOutlet weak var doneImage: UIImageView!
    
    var model: AddPriceRuleViewModel!
    
    var priceRulesViewModel: PriceRulesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)
        model = AddPriceRuleViewModel(networkManager: NetworkManager.shared)
        priceRulesViewModel = PriceRulesViewModel()
        
        doneImage.isHidden = true
        
        startDate.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        endDate.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
                
        updateUIForStartDate()
        updateUIForEndDate()

    }
    
    private func updateUIForStartDate() {
        let currentDate = Date()
        
        if startDate.date <= currentDate {
            startDate.date = currentDate
        }
                
        if endDate.date < startDate.date {
            endDate.date = startDate.date
        }
    }
    
    private func updateUIForEndDate() {
            let currentDate = Date()
            
            if endDate.date <= currentDate {
                endDate.date = currentDate
            }
            
            if endDate.date < startDate.date {
                endDate.date = startDate.date
            }
        }
        
        @objc func startDateChanged(_ datePicker: UIDatePicker) {
            updateUIForStartDate()
        }
        
        @objc func endDateChanged(_ datePicker: UIDatePicker) {
            updateUIForEndDate()
        }
    
    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        let startsAt = startDate.date
        let endsAt = endDate.date
        
        
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

        model.addPriceRule(title: title,
                              valueType: valueType,
                              value: String(value),
                              customerSelection: "all",
                              startsAt: startsAt,
                              endsAt: endsAt,
                              usageLimit: usageLimit) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success:
                       self?.showSuccessImageAndNavigateBack()
                   case .failure(let error):
                       self?.showSuccessImageAndNavigateBack()
                   }
               }
           }
       }

       private func showSuccessImageAndNavigateBack() {
           doneImage.isHidden = false
           UIView.animate(withDuration: 4.0, animations: {
               self.doneImage.alpha = 1.0
           }) { _ in
               UIView.animate(withDuration: 1.0) {
                   self.doneImage.alpha = 0.0
               } completion: { _ in
                   self.doneImage.isHidden = true
                   self.navigateBack()
               }
           }
       }

    
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
