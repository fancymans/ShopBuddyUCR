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
    
    // Update function
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shortestPathTableView.delegate = self
        self.shortestPathTableView.dataSource = self
        // setUpBusiness()
        shortestPathTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set up each ShortestPathCell here
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ShortestPathCell = tableView.dequeueReusableCellWithIdentifier("shortestPathCell") as ShortestPathCell
        cell.setCell("BestBuy", productName: "iPad", isProduct: false)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfBusinesses.count;
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
