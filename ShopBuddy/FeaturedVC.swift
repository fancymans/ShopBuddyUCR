//
//  featuredVC.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 10/31/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class FeaturedVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var featuredList: [NSString] = ["Gas Stations", "Restaurants", "Department Stores", "Drugstores", "Coffee & Tea", "Bars"]
    var currentFeaturedCellText: String = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "companyCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.featuredList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("companyCell") as UITableViewCell
        
        cell.textLabel.text = self.featuredList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("You selected cell #\(indexPath.row)!")
        
        // assign the query text before going to searchVC
        currentFeaturedCellText = featuredList[indexPath.row]
        self.performSegueWithIdentifier("goto_mainBoard", sender: tableView)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goto_mainBoard" {
            println("Segue Action: FeaturedVC -> SearchVC")
            var destinationVC: MainBoardVC = segue.destinationViewController as MainBoardVC
            destinationVC.segueIndex = 1;
            destinationVC.queryRequestText = currentFeaturedCellText
        }
    }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}

    

