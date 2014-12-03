//
//  ProductCell.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 11/17/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//
import UIKit

class ProductCell: UITableViewCell {
    
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var productName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
 
    func setCell (categoryName: String, productName: String, isProduct: Bool) {
        
        if isProduct {
            self.categoryName.text = ""
            self.productName.text = productName
        }
        else {
            self.categoryName.text = categoryName
            self.productName.text = ""
        }
    }
    
}
