//
//  ShoppingListVC.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 11/17/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate {
    
    @IBOutlet var shoppingListTable: UITableView!
    
    var arrayOfShoppingItems: [NSString] = [NSString] ()
    var queryText: String = ""
    var routeDistLimit = ["5 miles","10 miles","25 miles","50 miles","Nigga IDGAF take me to Antarctica"]
    
    var requestedLimit = "No Limit"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distLimitV.hidden = true
        // Do any additional setup after loading the view.
        self.shoppingListTable.delegate = self
        self.shoppingListTable.dataSource = self
        
        shoppingListTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBOutlet var distLimitV: UIView!
    
    @IBAction func BestRouteRequested(sender: AnyObject) {
        distLimitV.hidden = false
    }
    

    @IBAction func BestRouteRequestedDismiss(sender: AnyObject) {
        distLimitV.hidden = true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ShoppingCell = tableView.dequeueReusableCellWithIdentifier("shoppingItem") as ShoppingCell
        let currentItem = arrayOfShoppingItems[indexPath.row]
        cell.setCell (arrayOfShoppingItems[indexPath.row])
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfShoppingItems.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected custom cell #: " + String(format: "%i", indexPath.row))
    }
    
    func tableView(tableView: UITableView!, editingStyleForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.Delete;
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            arrayOfShoppingItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int
    {
        return routeDistLimit.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return "\(routeDistLimit[row])"
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        requestedLimit = "\(routeDistLimit[row])"
        
        //println("\(routeDistLimit[row])")
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goto_productsCatalog" {
            var nextVC: ProductsCatalogVC = segue.destinationViewController as ProductsCatalogVC
            nextVC.setPrevVC(self)
        }
        else if segue.identifier == "goto_BestRoute" {
            distLimitV.hidden = true
            
            var BestRouteVCReference: ShortestPathVC = segue.destinationViewController as ShortestPathVC
            //println("WENT THROUGHT THIS MOTHAFUCKAAAA")
            BestRouteVCReference.previousVC = self
            
        }
    }
}
