//
//  ShoppingCell.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 11/19/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import UIKit

class ShoppingCell: UITableViewCell {

    @IBOutlet var itemName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCell (itemName: String) {
        self.itemName.text = itemName
    }
}
