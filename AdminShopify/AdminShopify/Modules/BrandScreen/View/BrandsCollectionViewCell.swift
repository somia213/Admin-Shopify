//
//  BrandsCollectionViewCell.swift
//  AdminShopify
//
//  Created by Somia on 03/06/2024.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandImage: UIImageView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupUI()
        }
        
        private func setupUI() {
            contentView.layer.cornerRadius = 10
            contentView.layer.masksToBounds = true
            
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = 3
            layer.masksToBounds = false
        }
}
