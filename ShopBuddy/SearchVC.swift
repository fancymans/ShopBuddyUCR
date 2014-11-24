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
    var productSearchBarText: String = "default"
    var locationSearchBarText: String = "default"
    var gettingCurrentLocation: Bool = true
    var data: NSMutableData = NSMutableData()
    var currentProduct: Product = Product()
    var currentIndex: Int = Int()
    var listOfBusinesses: [Business] = [Business]()
    var totalListOfProducts: [Product] = [Product]()
    
    // Location manager
    let locationManager = CLLocationManager()
    
    // IBOutlets & Actions
    @IBOutlet var productSearchBar: UISearchBar!
    @IBOutlet var locationSearchBar: UISearchBar!
    @IBOutlet var resultsTable: UITableView!
    
    @IBAction func getCurrentLocation(sender: UIButton) {
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        gettingCurrentLocation = true
    }
    
    // Update function
    override func viewDidLoad() {
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
        resultsTable.reloadData()
    }
    
    // Memory warning detector
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //
    // MARK: - Table View functions
    // ____________________________________________________________
    // Function that sets up each cell inside the tableView
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ResultCell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as ResultCell
        let currentProduct = totalListOfProducts[indexPath.row]
        
        // Set up variables for the cell
        var tmpBusiness     = currentProduct.getBusiness(listOfBusinesses)
        var tmp_pName       = currentProduct.productName
        var tmp_bName       = tmpBusiness.name
        var tmp_price       = currentProduct.productPrice
        var tmp_time        = currentProduct.timeLastUpdated
        var tmp_user        = currentProduct.userLastUpdated
        var tmp_distance    = tmpBusiness.distance
        
        // Assign the variables for the cell
        cell.setCell(tmp_pName, bName: tmp_bName, price: tmp_price, time: tmp_time, user: tmp_user, distance: tmp_distance)
        return cell
    }
    // ____________________________________________________________
    
    // Function that returns the number of rows in the table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalListOfProducts.count
    }
    // ____________________________________________________________
    
    // Function that is automatically called when a cell is tapped or selected.
    // This is NOT called if the cell is set to segue to another view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected custom cell #: " + String(format: "%i", indexPath.row))
        currentProduct = totalListOfProducts[indexPath.row]
    }
    // ____________________________________________________________
    // END: - Table View functions
    // =======================================================================================================


    
    //
    // MARK: - Location functions
    // ____________________________________________________________
    // Function that gets the current location of the user
    func getCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        gettingCurrentLocation = true
    }
    // ____________________________________________________________
    
    // Function that updates the location when the search bar text is edited
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        // self.getCurrentLocation()
        searchBar.showsCancelButton = false
    }
    // ____________________________________________________________
    
    // Location Manager
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        if gettingCurrentLocation {
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
            // This function looks at the address put in the search bar and returns the latti and longi of said location
            CLGeocoder().geocodeAddressString(locationSearchBar.text, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    let location = CLLocationCoordinate2D( latitude: placemark.location.coordinate.latitude, longitude: placemark.location.coordinate.longitude )
                    println(location.longitude);
                    println(location.latitude);
                }   // end of if
            })      // end of function call
        }
        
    }
    // ____________________________________________________________
    
    // Check for error while getting location
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while trying to obtain location")
        println("Error " + error.localizedDescription)
    }
    // ____________________________________________________________
    
    // Function to show location info of a placemark
    func displayLocationInfo(placemark: CLPlacemark, manager: CLLocationManager) {
        // Stop updating location after location has been obtained (less battery strain)
        self.locationManager.stopUpdatingLocation()
        
        // Display location info
        println("City: " + placemark.locality)
        println("Zip Code: " + placemark.postalCode)
        println("State: " + placemark.administrativeArea)
        println("Country: " + placemark.country)
        
        // Assign location variable
        locationSearchBarText = String(placemark.locality as String + ", " + placemark.postalCode as String)
        queryLocationFromPHP(manager)
        self.viewDidLoad()
    }
    // ____________________________________________________________
    
    func queryLocationFromPHP(manager: CLLocationManager) {
        // Formatting lati and long into NSStrings to send
        var lati: NSString = NSString(format: "%.10f", manager.location.coordinate.latitude)
        var long: NSString = NSString(format: "%.10f", manager.location.coordinate.longitude)
        var post: NSString = NSString(format: "lati=" + lati + "&long=" + long)                     // Post is what we send as input to server
        var url: NSURL = NSURL(string:"http://shopbuddyucr.com/GetBusiness.php")!                   // URL of the PHP
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
            
            /*  Uncomment this code to print responseData to console
            ----------------------------------------------
            var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
            NSLog("Response ==> %@", responseData);
            */
            
            var error:NSError?
            var responseData: NSArray = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
            
            println("parsing business...")
            listOfBusinesses.removeAll(keepCapacity: false)
            totalListOfProducts.removeAll(keepCapacity: false)
            for var i = 0; i < responseData.count; i++ {
                var bLogo: String       = "100.jpg"
                var bCat: String        = "Gas Station" as String
                var bID: String         = responseData[i].objectForKey("ID") as String
                var bName: String       = responseData[i].objectForKey("Name") as String
                var bPhone: String      = responseData[i].objectForKey("PhoneNumber") as String
                var bAddress: String    = responseData[i].objectForKey("Address") as String
                var bDist: String       = responseData[i].objectForKey("dist") as String
                bLogo = updateLogo(bName)

                var tmpBusiness = Business(logo: bLogo, catergory: bCat, id: bID, name: bName, phoneNum: bPhone, address: bAddress, distance: bDist)
                
                /* Debug print code */
                print(i); print(": ")
                println("appending to listOfBusinesses")
                // */
                
                listOfBusinesses.append(tmpBusiness)
                self.storeAllProducts(tmpBusiness.listOfProducts)
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
            return "genericGas.png"
        }
    }
    // =======================================================================================================

    func storeAllProducts(productsFromBusiness: [Product]) {
        for var i = 0; i < productsFromBusiness.count; i++ {
            totalListOfProducts.append(productsFromBusiness[i])
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goto_Details" {
            println("going to Details")
            var i: NSIndexPath = resultsTable.indexPathForSelectedRow()!
            currentProduct = totalListOfProducts[i.row]
            var detailViewReference: Details = segue.destinationViewController as Details
            println("You need to fix setCurrentBusiness inside Details.swift")
            detailViewReference.setCurrentBusiness(Business())
            detailViewReference.setPreviousVC(self)
        }
    }

}
