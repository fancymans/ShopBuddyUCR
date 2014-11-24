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
    var listOfProducts: [Product]
    var dbURL: NSURL = NSURL(string: "http://shopbuddyucr.com/GetItems.php")!
    
    var distance: String
    
    init () {
        self.logo = "100.jpg"
        self.category = "category"
        self.id = "-1"
        self.name = "businessName"
        self.phoneNum = "5555555555"
        self.address = "0 DoesNotExist St., NoCity, NoState"
        self.distance = "0.0"
        self.listOfProducts = [Product]()
    }
    
    init (logo: String, catergory: String, id: String, name: String, phoneNum: String, address: String, distance: String) {
        self.logo = logo
        self.category = catergory
        self.id = id
        self.name = name
        self.phoneNum = phoneNum
        self.address = address
        self.distance = distance
        self.listOfProducts = [Product]()
        self.queryProductsFromDB()
    }
    
    func queryProductsFromDB () {
        var post: NSString = NSString(format: "StoreID=" + self.id)             // Post is what we send as input to server
        var url: NSURL = dbURL                                                  // URL of the PHP
        var postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!   // Encode the post
        var postLength: NSString = String( postData.length )                    // Length of the post
        
        // Creation of the request from url
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var reponseError: NSError?
        var response: NSURLResponse?
        
        // Send request and store the result inside urlData
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        // Check results; if nil that means nothing was retrieved. Otherwise, parse the data
        if (urlData != nil) {
            
            /*  Uncomment this code to print responseData to console
            ----------------------------------------------
                var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData);
            */

            var error:NSError?
            var responseData: NSArray = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
            
            println("Preparing to parse...")
            listOfProducts.removeAll(keepCapacity: false)
            for var i = 0; i < responseData.count; i++ {
                
                var pID: String = responseData[i].objectForKey("ID") as String
                var bID: String = self.id
                var pCategory: String = responseData[i].objectForKey("Category") as String
                var pName: String = responseData[i].objectForKey("ItemName") as String
                var pPrice: String = responseData[i].objectForKey("Price") as String
                var pTime: String = responseData[i].objectForKey("TimeLastUpdated") as String
                var pUser: String = responseData[i].objectForKey("UserLastUpdated") as String
                
                var tmpProduct = Product(pID: pID, bID: bID, category: "", productName: pName, price: pPrice, time: pTime, user: pUser, isProduct: true)
                print(i); print(": ")
                println("Appending product: " + pName)
                listOfProducts.append(tmpProduct)
            }
        }
    }
}