//
//  PriceRulesViewController.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

import UIKit

class PriceRulesViewController: UIViewController {

    
    @IBOutlet weak var priceRulesTable: UITableView!
    
    @IBOutlet weak var addNewPriceRule: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: "PriceRulesTableViewCell", bundle: nil)
        priceRulesTable.register(cell, forCellReuseIdentifier: "priceRulesCell")
        priceRulesTable.backgroundColor = UIColor.systemGray6
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
    
}

extension PriceRulesViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
