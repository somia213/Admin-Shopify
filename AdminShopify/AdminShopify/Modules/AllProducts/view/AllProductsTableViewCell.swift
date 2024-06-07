//
//  AllProductsTableViewCell.swift
//  AdminShopify
//
//  Created by Somia on 04/06/2024.
//

import UIKit

class AllProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productItemImg: UIImageView!
    
    @IBOutlet weak var productItemDescription: UILabel!
    
    @IBOutlet weak var productItemCountInStore: UILabel!
    
    @IBOutlet weak var productItemPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
               layer.shadowColor = UIColor.black.cgColor
               layer.shadowOffset = CGSize(width: 0, height: 2)
               layer.shadowOpacity = 0.4
               layer.shadowRadius = 2
               layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
               layer.shouldRasterize = true
               layer.rasterizationScale = UIScreen.main.scale
           }
           
           override func layoutSubviews() {
               super.layoutSubviews()
               layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
           }
           
           override func setSelected(_ selected: Bool, animated: Bool) {
               super.setSelected(selected, animated: animated)
               // Configure the view for the selected state
           }
           
       }
