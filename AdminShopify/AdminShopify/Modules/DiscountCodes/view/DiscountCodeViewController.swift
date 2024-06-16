//
//  DiscountCodeViewController.swift
//  AdminShopify
//
//  Created by Somia on 15/06/2024.
//

import UIKit

class DiscountCodeViewController: UIViewController {

    @IBOutlet weak var discountTable: UITableView!
    
    
    
    @IBAction func addNewDiscountCode(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Discount Code", message: "Enter the discount code", preferredStyle: .alert)
            
            alertController.addTextField { textField in
                textField.placeholder = "Discount Code"
            }
            
            let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                guard let textField = alertController.textFields?.first, let discountCode = textField.text else { return }
                
                self?.viewModel.postDiscountCode(code: discountCode) { [weak self] result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self?.viewModel.fetchDiscountCodes() 
                        }
                    case .failure(let error):
                        print("Failed to add discount code: \(error.localizedDescription)")
                    }
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(addAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
    }
    
    var viewModel: DiscountCodeViewModel!
           
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DiscountCodeViewModel(priceRuleId: viewModel.priceRuleId)
        
        viewModel.fetchDiscountCodes()
        
        viewModel.dataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.discountTable.reloadData()
            }
        }
        
        discountTable.dataSource = self
        discountTable.delegate = self
    }
}



   extension DiscountCodeViewController: UITableViewDataSource, UITableViewDelegate {
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return viewModel.discountCodes.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountCodeCell", for: indexPath)

           cell.textLabel?.text = "Discount Code:"
           cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
           cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)

           cell.detailTextLabel?.text = viewModel.discountCodes[indexPath.row].code
           cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
           cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
           cell.detailTextLabel?.textColor = UIColor.red

           return cell
       }

   }
