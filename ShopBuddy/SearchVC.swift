//
//  SearchVC.swift
//  ShopBuddy
//
//  Created by Darrin Lin on 11/8/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//


import UIKit
import CoreLocation

class SearchVC: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // Optional variables
    var productSearchBarText = "default"
    var locationSearchBarText = "default"
    var gettingCurrentLocation = false

    var data: NSMutableData = NSMutableData()
    var currentProduct: Product = Product()
    var currentIndex = Int()
    var listOfBusinesses: [Business] = [Business]()
    var totalListOfProducts: [Product] = [Product]()
    var sortBy = "Price"
    var distance: NSString = "60"
    var ccFilter = "0"
    var tfsFilter = "0"
    // Location manager
    var locationManager = CLLocationManager()
    
    // IBOutlets & Actions
    @IBOutlet var productSearchBar: UISearchBar!
    @IBOutlet var locationSearchBar: UISearchBar!
    @IBOutlet var resultsTable: UITableView!
    
    @IBAction func getCurrentLocation(sender: UIButton) {

        gettingCurrentLocation = true
        locationSearchBar.text = "getting current location..."
        getCurrentLocation()

    }
    
    @IBAction func searchTriggered(sender: AnyObject) {
        
        if (locationSearchBarText != locationSearchBar.text) {
            println("getting user requested location")
            gettingCurrentLocation = false
            getCurrentLocation()
        }
        
        resultsTable.reloadData()
    }
    
    // Update function
    override func viewDidLoad() {
        println("updating view did load")
        super.viewDidLoad()
        // If default text has been modified, auto-search query from searchBarText
        if productSearchBarText != "default" {
            productSearchBar.text = productSearchBarText
        }
        // If current location has been obtained, update search location text
        if locationSearchBarText != "default" {
            locationSearchBar.text = locationSearchBarText
            // self.locationManager.startUpdatingLocation()
        }

        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ResultCell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as ResultCell
        let currentProduct = totalListOfProducts[indexPath.row]
        
        // Set up variables for the cell
        var tmp_pName       = currentProduct.productName
        var tmp_bName       = currentProduct.businessName
        var tmp_price       = currentProduct.productPrice
        var tmp_time        = currentProduct.timeLastUpdated
        var tmp_user        = currentProduct.userLastUpdated
        var tmp_distance    = currentProduct.distance
        
        // Assign the variables for the cell
        cell.setCell(tmp_pName, bName: tmp_bName, price: tmp_price, time: tmp_time, user: tmp_user, distance: tmp_distance)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalListOfProducts.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected custom cell #: " + String(format: "%i", indexPath.row))
        currentProduct = totalListOfProducts[indexPath.row]
    }

    // Function that gets the current location of the user
    func getCurrentLocation() {
        println("I am updating location")
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        if gettingCurrentLocation {
            println("IF TRUE LOOP============")
            // This function gets the user's current location.
            CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error)->Void in
                if error != nil {
                    println("Reverse geocoder failed with error")
                    println("Error: " + error.localizedDescription)
                    return
                }
                
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    self.displayLocationInfo(pm, manager: manager)
                }
                else {
                    println("Error with data recv from geocoder")
                }
            })
        }
        
        else {
            println("ELSE TRUE LOOP============")
            CLGeocoder().geocodeAddressString(locationSearchBar.text, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
//                if let placemark = placemarks?[0] as? CLPlacemark {
//                    let location = CLLocationCoordinate2D( latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude )
//                    println(location.longitude);
//                    println(location.latitude);
//                }   // end of if
                if error != nil {
                    println("Reverse geocoder failed with error")
                    println("Error: " + error.localizedDescription)
                    return
                }
                
                if placemarks.count > 0 {
                    let pm = placemarks[0] as CLPlacemark
                    self.displayLocationInfo(pm, manager: manager)
                }
                else {
                    println("Error with data recv from geocoder")
                }
            })      // end of function call
        }
        
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while trying to obtain location")
        println("Error " + error.localizedDescription)
    }

    func displayLocationInfo(placemark: CLPlacemark, manager: CLLocationManager) {
        // stop updating the location
        manager.stopUpdatingLocation()
        
        // Display location info
        println("City: " + placemark.locality)
        println("Zip Code: " + placemark.postalCode)
        println("State: " + placemark.administrativeArea)
        println("Country: " + placemark.country)
        
        // Place location inside the search bar
        locationSearchBarText = String(placemark.locality as String + ", " + placemark.postalCode as String)
        
        queryLocationFromPHP(manager)
        self.viewDidLoad()
    }

    func queryLocationFromPHP(manager: CLLocationManager) {
        // Formatting lati and long into NSStrings to send
        var lati: NSString = NSString(format: "%.10f", manager.location.coordinate.latitude)
        var long: NSString = NSString(format: "%.10f", manager.location.coordinate.longitude)
        
        var distancePost: NSString = NSString(format: "&distance="  + distance)
        
        var ccPost: NSString = NSString(format: "&cc=" + ccFilter)
        var tfsPost: NSString = NSString(format: "&tfs=" + tfsFilter)
        
        var post: NSString = NSString(format: "lati=" + lati + "&long=" + long + "&sort=" + sortBy + distancePost + ccPost + tfsPost)
        
        //var distancePost: NSString = NSString(format: "&distance" + distance)
        
        // Post is what we send as input to server
        var url: NSURL = NSURL(string:"http://shopbuddyucr.com/GetProducts.php")!                   // URL of the PHP
        var postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        println("post: " + post)
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

            var error:NSError?
            
            var responseData: NSArray = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
            
            //println("parsing business...")
            listOfBusinesses.removeAll(keepCapacity: false)
            totalListOfProducts.removeAll(keepCapacity: false)
            
            for var i = 0; i < responseData.count; i++ {
                
                var bID: String                 = responseData[i].objectForKey("ID") as String
                var bName: String               = responseData[i].objectForKey("Name") as String
                var pCategory: String           = responseData[i].objectForKey("Category") as String
                var pID : String                = responseData[i].objectForKey("ItemID") as String
                var pName: String               = responseData[i].objectForKey("ItemName") as String
                var pPrice: String              = responseData[i].objectForKey("Price") as String
                var pTime: String               = responseData[i].objectForKey("TimeLastUpdated") as String
                var pUser: String               = responseData[i].objectForKey("UserLastUpdated") as String
                var pDist: String               = responseData[i].objectForKey("dist") as String
                var creditCardAccept: String    = responseData[i].objectForKey("cc") as String
                var pCcFlag: Bool               = false
                var open24Hours: String         = responseData[i].objectForKey("open24") as String
                var pOpen24Flag: Bool           = false
                
                if creditCardAccept == "1" {
                    pCcFlag = true
                }
                if open24Hours == "1" {
                    pOpen24Flag = true
                }
                
                var tmpProduct = Product(bID: bID, businessName: bName, category: pCategory, pID: pID, productName: pName, price: pPrice, time: pTime, user: pUser, dist: pDist, ccFlag: pCcFlag, open24Flag: pOpen24Flag, isProduct: true)
                
                //* Debug print code
                print(i); print(". ")
                println("Appending product: " + pName)
                // */
                
                totalListOfProducts.append(tmpProduct)
            }
        }
    }
    
    func updateLogo (businessName: String) -> String {
        if businessName == "7-Eleven" {
            return "genericGas.png"
        }
        else if businessName == "76" {
            return "76.jpg"
        }
        else if businessName == "Allsup's" {
            return "allsups.png"
        }
        else if businessName == "Arco" {
            return "arco.png"
        }
        else if businessName == "Cheveron" {
            return "chevron.jpg"
        }
        else if businessName == "Circle K" {
            return "circleK.png"
        }
        else if businessName == "Costco" {
            return "costco.jpg"
        }
        else if businessName == "Food4less" {
            return "food4less.png"
        }
        else if businessName == "Mobil" {
            return "mobil.jpg"
        }
        else if businessName == "Shell" {
            return "shell.jpg"
        }
        else if businessName == "Thrifty" {
            return "76.jpg"
        }
        else if businessName == "USA Gasoline" {
            return "genericGas.png"
        }
        else if businessName == "Weis Service Station" {
            return "westerGas.png"
        }
        else {
            return "sampleBusinessPhoto.png"
        }
    }

    func storeAllProducts(productsFromBusiness: [Product]) {
        for var i = 0; i < productsFromBusiness.count; i++ {
            totalListOfProducts.append(productsFromBusiness[i])
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goto_Details" {
            println("going to Details")
            var i: NSIndexPath = resultsTable.indexPathForSelectedRow()!
            currentProduct = totalListOfProducts[i.row]
            var detailViewReference: Details = segue.destinationViewController as Details
            println("You need to fix setCurrentBusiness inside Details.swift")
            detailViewReference.previousVC = self
        }
        else if segue.identifier == "goto_Filter" {
            var FilterVCReference: Filter = segue.destinationViewController as Filter
            FilterVCReference.previousVC = self
        }
    }

}
