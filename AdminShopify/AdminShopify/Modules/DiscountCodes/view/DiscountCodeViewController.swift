//
//  DiscountCodeViewController.swift
//  AdminShopify
//
//  Created by Somia on 15/06/2024.
//

import UIKit

class DiscountCodeViewController: UIViewController {

    @IBOutlet weak var discountTable: UITableView!
    
    var viewModel: DiscountCodeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = DiscountCodeViewModel(priceRuleId: viewModel.priceRuleId)
        
        discountTable.dataSource = self
        discountTable.delegate = self
        
        viewModel.fetchDiscountCodes()
        
        viewModel.dataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.discountTable.reloadData()
            }
        }
    }
    
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
                        let successAlert = UIAlertController(title: "Success", message: "Discount code added successfully", preferredStyle: .alert)
                        self?.present(successAlert, animated: true, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            successAlert.dismiss(animated: true) {
                                self?.viewModel.fetchDiscountCodes()
                                
                                self?.discountTable.reloadData()
                                
                                self?.dismiss(animated: true, completion: nil)
                            }
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

    
    @IBAction func cancelBtn(_ sender: Any) {
        navigateBack()
    }
    
    func navigateBack() {
        dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "Delete Discount Code", message: "Are you sure you want to delete this discount code?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let discountCodeIdToDelete = self.viewModel.discountCodes[indexPath.row].id
                
                self.viewModel.deleteDiscountCode(discountCodeId: discountCodeIdToDelete) { result in
                    switch result {
                    case .success:
                        self.viewModel.discountCodes.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        print("Discount code deleted successfully.")
                        
                    case .failure(let error):
                        print("Failed to delete discount code: \(error.localizedDescription)")
                    }
                }
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}
