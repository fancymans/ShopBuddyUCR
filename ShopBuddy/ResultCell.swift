//
//  ResultCell.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 11/8/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet var productName: UILabel!
    @IBOutlet var businessName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var user: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var lastUpdatedString: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell (logo: String, price: String, time: String, user: String, distance: String) {
        
        self.productName.text = ""
        self.businessName.text = ""
        self.price.text = "$" + price
        self.time.text = time
        self.user.text = user
        self.distance.text = distance + " mi."
    }
    
    func setCell (pName: String, bName: String, price: String, time: String, user: String, distance: String) {
        self.productName.text = pName
        self.businessName.text = bName
        self.price.text = "$" + price
        self.time.text = time
        self.user.text = user
        self.distance.text = distance + " mi."
    }
}
