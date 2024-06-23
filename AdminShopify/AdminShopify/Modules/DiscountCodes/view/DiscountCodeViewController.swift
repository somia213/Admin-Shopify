//
//  DiscountCodeViewController.swift
//  AdminShopify
//
//  Created by Somia on 15/06/2024.
//

import UIKit
import Lottie

class DiscountCodeViewController: UIViewController {

    @IBOutlet weak var discountTable: UITableView!
    @IBOutlet weak var indecatorView: UIActivityIndicatorView!
    @IBOutlet weak var doneImage: UIImageView!
    var viewModel: DiscountCodeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        indecatorView.style = .large
        indecatorView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        viewModel = DiscountCodeViewModel(priceRuleId: viewModel.priceRuleId)
        
        discountTable.dataSource = self
        discountTable.delegate = self
        
        viewModel.fetchDiscountCodes()
        
        viewModel.dataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.discountTable.reloadData()
                self?.indecatorView.stopAnimating()
                self?.indecatorView.isHidden = true
            }
        }
        doneImage.isHidden = true
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
                        self?.dismiss(animated: true, completion: nil)
                        self?.showSuccessImageAndNavigateBack()
                case .failure(_):
                    print("Failed to add discount code:")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showSuccessImageAndNavigateBack() {
        doneImage.isHidden = false
        UIView.animate(withDuration: 2.0, animations: {
            self.doneImage.alpha = 1.0
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                UIView.animate(withDuration: 2.0, animations: {
                    self.doneImage.alpha = 0.0
                }) { _ in
                    self.doneImage.isHidden = true
                    self.navigateBack()
                }
            }
        }
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
         let count = viewModel.discountCodes.count
         tableView.backgroundView = count == 0 ? createNoDataLabel() : nil
         return count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "DiscountCodeCell", for: indexPath)

         cell.textLabel?.text = "Discount Code:"
         cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)

         cell.detailTextLabel?.text = viewModel.discountCodes[indexPath.row].code
         cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 15)
         cell.detailTextLabel?.textColor = UIColor.orange

         return cell
     }

     private func createNoDataLabel() -> UILabel {
         let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: discountTable.bounds.size.width, height: discountTable.bounds.size.height))
         noDataLabel.text = "No discount codes available"
         noDataLabel.textAlignment = .center
         noDataLabel.textColor = UIColor.orange
         noDataLabel.font = UIFont.systemFont(ofSize: 18)
         return noDataLabel
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
