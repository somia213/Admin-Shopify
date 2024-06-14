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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = AddNewProductPresenter(view: self)
        model = AddPriceRuleViewModel(networkManager: NetworkManager.shared)

    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        guard let title = priceRuleTotle.text, !title.isEmpty else {
                showAlert(message: "Please enter a title.")
                return
            }

            let valueType = priceRuleType.titleForSegment(at: priceRuleType.selectedSegmentIndex) ?? ""

        guard let valueText = discountAmount.text, !valueText.isEmpty, let value = Double(valueText), value < 0 && value >= -100 else {
                showAlert(message: "Please enter a discount amount between -100 and 0.")
                return
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
                        self?.navigateBack()
                    case .failure(let error):
                        self?.showAlert(message: error.localizedDescription)
                    }
                }
            }
    }
    
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
    func showAlert(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
