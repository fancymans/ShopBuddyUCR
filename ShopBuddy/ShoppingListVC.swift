//
//  ShoppingListVC.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 11/17/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import UIKit

class ShoppingListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var shoppingListTable: UITableView!
    
    var arrayOfShoppingItems: [String] = [String] ()
    var queryText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.shoppingListTable.delegate = self
        self.shoppingListTable.dataSource = self
        
        shoppingListTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goto_productsCatalog" {
            var nextVC: ProductsCatalogVC = segue.destinationViewController as ProductsCatalogVC
            nextVC.setPrevVC(self)
        }
    }
}
