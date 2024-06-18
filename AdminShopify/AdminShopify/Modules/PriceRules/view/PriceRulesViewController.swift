//
//  PriceRulesViewController.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

//
//  PriceRulesViewController.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

import UIKit

class PriceRulesViewController: UIViewController {

    @IBOutlet weak var priceRulesTable: UITableView!
    var viewModel: PriceRulesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = PriceRulesViewModel()
        
        viewModel.dataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.priceRulesTable.reloadData()
            }
        }
        
        let cellNib = UINib(nibName: "PriceRulesTableViewCell", bundle: nil)
        priceRulesTable.register(cellNib, forCellReuseIdentifier: "priceRulesCell")
        priceRulesTable.backgroundColor = UIColor.systemGray6
        
      //  viewModel.fetchPriceRules()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          viewModel.fetchPriceRules()
      }

    @IBAction func addNewPriceRule(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addPriceRuleVC = storyboard.instantiateViewController(withIdentifier: "AddNewPriceRuleViewController") as! AddNewPriceRuleViewController
        
        addPriceRuleVC.modalPresentationStyle = .fullScreen
        addPriceRuleVC.priceRulesViewModel = viewModel

        self.present(addPriceRuleVC, animated: true, completion: nil)
    }
    
    private func showAlertToDeletePriceRule(at indexPath: IndexPath) {
        guard indexPath.row < viewModel.priceRules.count else {
            print("Error: Index out of range for priceRules at indexPath: \(indexPath)")
            return
        }
        
        let priceRule = viewModel.priceRules[indexPath.row]
        
        let alertController = UIAlertController(title: "Delete Price Rule", message: "Are you sure you want to delete this price rule?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            self.viewModel.deletePriceRule(priceRuleId: priceRule.id) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.priceRulesTable.beginUpdates()
                        if let index = self.viewModel.priceRules.firstIndex(where: { $0.id == priceRule.id }) {
                            self.viewModel.priceRules.remove(at: index)
                            self.priceRulesTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
                        self.priceRulesTable.endUpdates()
                    }
                case .failure(let error):
                    print("Failed to delete price rule: \(error)")
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension PriceRulesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.priceRules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceRulesCell", for: indexPath) as! PriceRulesTableViewCell
        
        let priceRule = viewModel.priceRules[indexPath.row]
        if let negativeValue = Double(priceRule.value), negativeValue < 0 {
            let positiveValue = -negativeValue
            cell.rateOfDicountPerMoney.text = "\(positiveValue) OFF"
        } else {
            cell.rateOfDicountPerMoney.text = "\(priceRule.value) OFF"
        }

        cell.endDateOfDicount.text = priceRule.ends_at
        cell.maxUsageRate.text = "\(priceRule.usage_limit) Max Usage"
        cell.startDateOfDicount.text = priceRule.starts_at
      //  cell.rateOfDicountPerMoney.text = (priceRule.value)
        cell.discountTitleLabel.text = priceRule.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let discountCodeVC = storyboard.instantiateViewController(withIdentifier: "DiscountCodeViewController") as! DiscountCodeViewController

        discountCodeVC.viewModel = DiscountCodeViewModel(priceRuleId: viewModel.priceRules[indexPath.row].id)
        discountCodeVC.modalPresentationStyle = .fullScreen
        present(discountCodeVC, animated: true, completion: nil)
    }

}

extension PriceRulesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showAlertToDeletePriceRule(at: indexPath)
        }
    }
        

}
