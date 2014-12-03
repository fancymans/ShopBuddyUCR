//
//  ShortestPathVC.swift
//  ShopBuddy
//
//  Created by Darrin Lin on 11/19/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import UIKit

class ShortestPathVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var shortestPathTableView: UITableView!
    var listOfBusinesses: [Business] = [Business]()
    var arrayOfResults: [String] = [String]()
    var wishlist: [Product] = [Product]()
    var previousVC: ShoppingListVC = ShoppingListVC()
    var outofRange: [String] = [String]()
    var outofRangeFlag: Bool = false
    var dists: [Double] = [Double]()
    
    // Update function
    override func viewDidLoad() {
        super.viewDidLoad()
        //println("Distance Limit: " + previousVC.requestedLimit)
        self.shortestPathTableView.delegate = self
        self.shortestPathTableView.dataSource = self
        // setUpBusiness()
        wishlist.removeAll(keepCapacity: false)
        
        for (index, value) in enumerate(previousVC.arrayOfShoppingItems) {
           // println("Item \(index + 1): \(value)")
            pullCheapestProductFromPHP(value, distLimit: previousVC.requestedLimit)
            if(outofRangeFlag == true) {
                outofRange.append(value)
                outofRangeFlag = false
            }
            
        }
       
            //println(outofRange)
        
        if(outofRange.count >= 1) {
            var alert:UIAlertView = UIAlertView()
            alert.title = "Product(s) not within Range!"
            var text = "These items are not close enough to you: \n"
            for var i = 0; i < outofRange.count; i++ {
                text = text + outofRange[i] + "\n"
            }
            alert.message = text
            alert.delegate = self
            alert.addButtonWithTitle("Got It")
            alert.show()
        }
        
       // let numMin = dists.reduce(Int.max, { min($0, $1) })
        if(dists.count != 0) {
            var maxDist = minElement(dists)
        }
        
        shortestPathTableView.reloadData()
    }

    func pullCheapestProductFromPHP(itemName: NSString, distLimit: NSString){
            println("Distance Limit Sent:    " +  distLimit)
            println("                        " + itemName)
            var post: NSString = NSString(format: "&itemname=" + itemName + "&distlimit=" + distLimit)
        
       
            //var distancePost: NSString = NSString(format: "&distance" + distance)
            
            // Post is what we send as input to server
            var url: NSURL = NSURL(string:"http://shopbuddyucr.com/ReturnProduct.php")!                   // URL of the PHP
            var postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength: NSString = String( postData.length )
            var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            var reponseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
            if (urlData != nil) {
                
                //  Comment this line to print responseData to console
                //----------------------------------------------
                //var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                //NSLog("Response ==> %@", responseData);
                //
                
                var error:NSError?
                
                var responseData: NSArray = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
                
                if(responseData.count == 0){
                    println("You got no results back nigger")
                    outofRangeFlag = true
                }
                else{
                   // println("Yes results baby")
                }
                //println("parsing business...")
                listOfBusinesses.removeAll(keepCapacity: false)
               // totalListOfProducts.removeAll(keepCapacity: false)
                
                
                for var i = 0; i < responseData.count; i++ {
                    var pName: String               = responseData[i].objectForKey("ItemName") as String
                    var Price: String               = responseData[i].objectForKey("Price") as String
                    var bName: String               = responseData[i].objectForKey("Name") as String
                    var Address: String             = responseData[i].objectForKey("Address") as String
                    var PhoneNumber: String         = responseData[i].objectForKey("PhoneNumber") as String
                    var Longitude: String           = responseData[i].objectForKey("Longi") as String
                    var Latitude: String            = responseData[i].objectForKey("Latti") as String
                    var Distance: NSString          = responseData[i].objectForKey("dist") as NSString
                    //println(Distance + "   " + Address)
                 //   var tmpProduct = Product(bID: bID, businessName: bName, category: pCategory, pID: pID, productName: pName, price: pPrice, time: pTime, user: pUser, dist: pDist, ccFlag: pCcFlag, open24Flag: pOpen24Flag, isProduct: true)
                    
                    //* Debug print code
                    //print(i); print(". ")

                        //println("Appending product: " + pName )
                        //println(Distance)
                        //println("Price: " + Price)
                        // */
                    
                    var temp: Product = Product(bID: bName, businessName: bName, category: Address, pID: PhoneNumber, productName: pName, price: Price, time: "nade", user: "nada", dist: Distance, ccFlag: false, open24Flag: false, isProduct: true)
                    wishlist.append(temp)
                    
                        dists.append(Distance.doubleValue)

                  //  totalListOfProducts.append(tmpProduct)
                }
                
            }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTrigger(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //previousVC.viewDidLoad()
    }
    
    // Set up each ShortestPathCell here
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ShortestPathCell = tableView.dequeueReusableCellWithIdentifier("shortestPathCell") as ShortestPathCell
        var businessName = wishlist[indexPath.row].businessName
        var businessAddress = wishlist[indexPath.row].category
        var businessPhoneNumber = wishlist[indexPath.row].productID
        println(businessName)
        var distance = wishlist[indexPath.row].distance
        let myrange = Range(start:advance(distance.startIndex,1), end: advance(distance.startIndex,5))

        distance = distance.substringWithRange(myrange)
        var productName = wishlist[indexPath.row].productName
        var price = wishlist[indexPath.row].productPrice
        
        cell.setCell(businessName, productName: productName, isProduct: true, productDistance: distance, businessPhoneNumber: businessPhoneNumber, businessAddress: businessAddress, pprice: price, number: indexPath.row+1)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlist.count;
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    // Temporary function to add values into the "wishlist"
    /*
    func setUpBusiness() {
        println("Setup Business")
        listOfBusinesses.append(Business (logo: "100.jpg", catergory: "Gas Station", id: "1", name: "Bob", phoneNum: "###", address: "Addr", price87: "0.00", price89: "0.00", price91: "0.00", priceD: "0.00", timeLastUdpated: "0:00", userLastUpdated: "Joe", distance: "1.2"))
    }
    */
    
    /*
    func setUpResults() {
        for var i = 0; i < listOfBusinesses.count; i++ {
            var businessName = listOfBusinesses[i].name
            arrayOfResults.append(businessName)
            for var j = 0; j < listOfBusinesses.listOfProducts.count; i++ {
                var productName = listOfProducts[j].productName
                arrayOfResults.append(productName)
            }
        }
    }
    */
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
