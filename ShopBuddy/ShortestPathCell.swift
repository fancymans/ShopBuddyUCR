//
//  ShortestPathCell.swift
//  ShopBuddy
//
//  Created by Darrin Lin on 11/19/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import UIKit

class ShortestPathCell: UITableViewCell {
    
    @IBOutlet var businessName: UILabel!
    @IBOutlet var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell (businessName: String, productName: String, isProduct: Bool) {
        if isProduct {
            // If the current cell is a product, set the product name
            self.productName.text = productName
        }
        else {
            // If it's not a product, set the business name
            self.businessName.text = businessName
        }
    }
}