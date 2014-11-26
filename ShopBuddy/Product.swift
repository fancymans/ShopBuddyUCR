//
//  Product.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 11/17/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import Foundation

class Product {
    // Business vars
    var businessID: String
    var businessName: String
    var category: String
    
    // Product vars
    var productName: String
    var productPrice: String
    var timeLastUpdated: String
    var userLastUpdated: String
    var distance: String
    var ccFlag: Bool
    var open24Flag: Bool
    var isProduct: Bool
    
    init () {
        self.businessID         = "-1"
        self.businessName       = "Default Business Name"
        self.category           = "Default Catagory Name"
        self.productName        = "Default Product Name"
        self.productPrice       = "0.00"
        self.timeLastUpdated    = "0 minutes ago"
        self.userLastUpdated    = "DefaultUser"
        self.distance           = "0"
        self.ccFlag             = false
        self.open24Flag         = false
        self.isProduct          = false
    }
    
    init (category: String, productName: String) {
        self.businessID         = "n/a"
        self.businessName       = "Default Business Name"
        self.category           = category
        self.productName        = productName
        self.productPrice       = "n/a"
        self.timeLastUpdated    = "n/a"
        self.userLastUpdated    = "System"
        self.distance           = "0"
        self.ccFlag             = false
        self.open24Flag         = false
        
        if (self.productName == "") {
            isProduct = false
        }
        else {
            isProduct = true
        }
    }
    
    init (category: String, productName: String, isProduct: Bool) {
        self.businessID         = "n/a"
        self.businessName       = "Default Business Name"
        self.category           = category
        self.productName        = productName
        self.productPrice       = "0.00"
        self.timeLastUpdated    = "0 minutes ago"
        self.userLastUpdated    = "DefaultUser"
        self.distance           = "0"
        self.ccFlag             = false
        self.open24Flag         = false
        self.isProduct          = isProduct
    }
    
    init (bID: String, businessName: String, category: String, productName: String, price: String, time: String, user: String, dist: String, ccFlag: Bool, open24Flag: Bool, isProduct: Bool) {
        self.businessID         = bID
        self.businessName       = businessName
        self.category           = category
        self.productName        = productName
        self.productPrice       = price
        self.timeLastUpdated    = time
        self.userLastUpdated    = user
        self.distance           = dist
        self.ccFlag             = ccFlag
        self.open24Flag         = open24Flag
        self.isProduct          = isProduct
    }
    
    
    // Goes thru each business and tried to find the business that "self" (aka this product) belongs to.
    func getBusiness(listOfBusinesses: [Business]) -> Business {
        for var i = 0; i < listOfBusinesses.count; i++ {
            if self.businessID == listOfBusinesses[i].id {
                // Business has been found, return the business
                println("Business: " + listOfBusinesses[i].name + " found")
                return listOfBusinesses[i]
            }
        }
        
        println("Business with matching ID was not found, returning default business...")
        return Business()
    }
}