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
    

    @IBOutlet var Order: UILabel!
    @IBOutlet var Price: UILabel!

    @IBOutlet var Address: UILabel!
    
    @IBOutlet var Distance: UILabel!
    @IBOutlet var PhoneNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell (businessName: String, productName: String, isProduct: Bool, productDistance: String, businessPhoneNumber: String, businessAddress: String, pprice: String, number: Int) {
        
            // If the current cell is a product, set the product name
            self.productName.text = productName
            self.Distance.text = productDistance
            self.PhoneNumber.text = businessPhoneNumber
            self.Order.text = String(format: "%i",number) + "."
            self.Address.text = businessAddress
            self.Price.text = pprice
            // If it's not a product, set the business name
            self.businessName.text = businessName
        
    }
}