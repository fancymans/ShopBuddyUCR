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
    var route: [Product] = [Product]()
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
        var temp: [Product] = wishlist
        
        println("-------------Products and their Ordering!!!!!!!!!!-------------------")
       for (index, value) in enumerate(wishlist) {
          //  println(value.productName + "       " + value.distance)
        }
        
        while(temp.count != 0 ){

            temp = findClosest(temp)
        
            println("-------------Queue After Extraction-------------------")
        
            for (index, value) in enumerate(temp) {
            println(value.productName + "       " + value.distance)
            }
        }
        wishlist = route
        
            //println(outofRange)
        
        if(outofRange.count >= 1) {
            var alert:UIAlertView = UIAlertView()
            alert.title = "Product(s) Not Found!"
            var text = "These items are not within your Range: \n"
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

    func findClosest(productArr: [Product]!) -> [Product]
    {
        var closestLocationIndex = 0
        var closestDist = 9999.0
        println("-------------QUEUE BEFORE-------------------")
        for (index, value) in enumerate(productArr) {
            println(value.productName + "       " + value.distance)
            
            var tmp : Double = NSString(string: value.distance).doubleValue
            //var tmp = value.distance.toInt()

            if( tmp <= closestDist){
                closestDist = tmp
                closestLocationIndex = index
            }
        }
        
        route.append(productArr[closestLocationIndex])
        
        println("-------------THROWN IN ROUTE-------------------")
        
        for (index, value) in enumerate(route) {
            println(value.productName + "       " + value.distance)
        }
        
        
        var currentLong = NSString(string: productArr[closestLocationIndex].timeLastUpdated).doubleValue
        var currentLat = NSString(string: productArr[closestLocationIndex].userLastUpdated).doubleValue
        var tmp: [Product] = [Product]()
        for (index, value) in enumerate(productArr) {
            //println(value.productName + "       " + value.distance)
            if(index != closestLocationIndex){
                tmp.append(value)
            }
        }
        /*
        if(tmp.count != 0){
            for (index, value) in enumerate(tmp) {
                var productLong = NSString(string: value.timeLastUpdated).doubleValue
                var productLat = NSString(string: value.userLastUpdated).doubleValue
                
                println("Calculate new distance")
                
                println("Long1: " + String(format: "%.10f", currentLong) + "Lat1: " + String(format: "%.10f", currentLong))
                println( "Long2: " + String(format: "%.10f", productLong) + "Lat2: " + String(format: "%.10f", productLat))
                value.distance = String(format: "%.10f", findDist(currentLong, lat: currentLat, long2: productLong, lat2: productLat))
            
            }
            
        }*/

        
        return tmp
        
    }
    
    func findDist(long: Double, lat: Double, long2: Double, lat2: Double) -> Double {
       
         //sqrt(pow(abs(long - long2),2) + pow(abs(lat - lat2),2))
        
        var radian = 0.0174532925
        var theta = long - long2
        var dist = sin(lat * radian) * sin(lat2 * radian) * cos(lat * radian) * cos(lat2 * radian) * cos(theta * radian)
        dist = acos(dist)
        dist = dist/radian
        var miles = dist * 60 * 1.1515
        return miles
    }
    
    func pullCheapestProductFromPHP(itemName: NSString, distLimit: NSString){
           // println("Distance Limit Sent:    " +  distLimit)
            //println("                        " + itemName)
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
                    //println("You got no results back nigger")
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
                    
                    var temp: Product = Product(bID: bName, businessName: bName, category: Address, pID: PhoneNumber, productName: pName, price: Price, time: Longitude, user: Latitude, dist: Distance, ccFlag: false, open24Flag: false, isProduct: true)
                    
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
       // println(businessName)
        var distance = wishlist[indexPath.row].distance
        let myrange = Range(start:advance(distance.startIndex,0), end: advance(distance.startIndex,5))

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
