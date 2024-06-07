//
//  PriceRulesViewController.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

import UIKit

class PriceRulesViewController: UIViewController {

    
    @IBOutlet weak var priceRulesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: "PriceRulesTableViewCell", bundle: nil)
        priceRulesTable.register(cell, forCellReuseIdentifier: "priceRulesCell")
        priceRulesTable.backgroundColor = UIColor.systemGray6
    }
    
    @IBAction func addNewPriceRule(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let addPriceRule = storyboard.instantiateViewController(withIdentifier: "AddNewPriceRuleViewController") as! AddNewPriceRuleViewController
        
        addPriceRule.modalPresentationStyle = .fullScreen

                self.present(addPriceRule, animated: true, completion: nil)
    }
    
    private func showAlertToAddCoupon() {
        let alertController = UIAlertController(title: "Add Coupon", message: "Enter your coupon code:", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Coupon Code"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .default) { (action) in
            if let textField = alertController.textFields?.first, let couponCode = textField.text {
                print("Entered coupon code: \(couponCode)")
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
}

extension PriceRulesViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceRulesCell", for: indexPath) as! PriceRulesTableViewCell
        cell.discountLabel.text = "50% OFF"
        cell.endDateOfDicount.text = "29 june 10:30PM"
        cell.maxUsageRate.text = "10 Max Usage"
        cell.startDateOfDicount.text = "26 june 10:30PM"
        cell.rateOfDicountPerMoney.text = "-50% After 300.0$"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            showAlertToAddCoupon()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
}

extension PriceRulesViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
