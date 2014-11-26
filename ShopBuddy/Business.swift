//
//  Business.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 10/31/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import Foundation

class Business {
    
    var logo: String
    var category: String
    var id: String
    var name: String
    var phoneNum: String
    var address: String
    var dbURL: NSURL = NSURL(string: "http://shopbuddyucr.com/GetBusinessbackup.php")!
    
    var distance: String
    
    init () {
        self.logo = "100.jpg"
        self.category = "category"
        self.id = "-1"
        self.name = "businessName"
        self.phoneNum = "5555555555"
        self.address = "0 DoesNotExist St., NoCity, NoState"
        self.distance = "0.0"
    }
    
    init (logo: String, catergory: String, id: String, name: String, phoneNum: String, address: String, distance: String) {
        self.logo = logo
        self.category = catergory
        self.id = id
        self.name = name
        self.phoneNum = phoneNum
        self.address = address
        self.distance = distance
        // self.queryProductsFromDB()
    }
    
    // queries PHP and returns an array of every Business from the database
    func getListOfBusinesses () ->[Business] {
        var result: [Business] = [Business]()
        var url: NSURL = dbURL                                                  // URL of the PHP
        var data: NSData = NSData(contentsOfURL: url)!
        
        // Check results; if nil that means nothing was retrieved. Otherwise, parse the data
        if data.length >= 0 {
            
            /*  Uncomment this code to print responseData to console
            ----------------------------------------------
                var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData);
            */

            var error:NSError?
            var responseData: NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
            
            println("Preparing to parse...")
            result.removeAll(keepCapacity: false)
            for var i = 0; i < responseData.count; i++ {
                
                var bID: String = responseData[i].objectForKey("ID") as String
                var bName: String = responseData[i].objectForKey("Name") as String
                var bPhone: String = responseData[i].objectForKey("PhoneNumber") as String
                var bAddress: String = responseData[i].objectForKey("Address") as String
                var bDist: String = responseData[i].objectForKey("dist") as String
                
                var tmpBusiness: Business = Business(logo: "", catergory: "", id: bID, name: bName, phoneNum: bPhone, address: bAddress, distance: bDist)
                print(i); print(": ")
                println("Appending Business: " + bName)
                result.append(tmpBusiness)
            }
        }
        
        return result
    }
}