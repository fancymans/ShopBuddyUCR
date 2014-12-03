//
//  Filter.swift
//  ShopBuddy
//
//  Created by Valeed Malik on 11/11/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

// Hey kenneth can you see this??

class Filter: UIViewController, UIPickerViewDelegate {

    var brands = []
    var brandFilter = "No Filter"
    var ccFilter = 0
    var tfsFilter = 0
    var carwashFilter = 0
    var previousVC: SearchVC = SearchVC()
   
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        initsort()
        initDistance()
        initcc()
        inittfs()
        
        brands = ["No Filter","Chevron","76", "Mobile", "100", "Arco", "USA Gasoline", "711", "Circle K", "Costco", "Food 4 Less"]

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTrigger(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //previousVC.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initcc() {
        if(previousVC.ccFilter == "0") {
            ccSwitch.on = false
        }
        else if(previousVC.ccFilter == "1") {
            ccSwitch.on = true
        }
    }

    func inittfs() {
        if(previousVC.tfsFilter == "0") {
            tfsSwitch.on = false
        }
        else if(previousVC.tfsFilter == "1") {
            tfsSwitch.on = true
        }
    }
    
    func initsort() {
        if(previousVC.sortBy == "dist") {
            SortSC.selectedSegmentIndex = 1
        }
        else if(previousVC.sortBy == "Price") {
            SortSC.selectedSegmentIndex = 0
        }
    }
    
    func initDistance() {
        if(previousVC.distance == "5") {
            DistanceSC.selectedSegmentIndex = 0
        }
        else if(previousVC.distance == "10") {
            DistanceSC.selectedSegmentIndex = 1
        }
        else if(previousVC.distance == "20") {
            DistanceSC.selectedSegmentIndex = 2
        }
        else if(previousVC.distance == "60") {
            DistanceSC.selectedSegmentIndex = 3
        }
        else if(previousVC.distance == "99999") {
            DistanceSC.selectedSegmentIndex = 4
        }
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int
    {
        return brands.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return "\(brands[row])"
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        brandFilter = "\(brands[row])"
        println("\(brands[row])")
        
    }
 

    @IBOutlet var DistanceSC: UISegmentedControl!

    @IBAction func GradeSelected(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            println("10 segement clicked")
            previousVC.distance = "5"
        case 1:
            println("89 segment clicked")
            previousVC.distance = "10"
        case 2:
            println("92 segemnet clicked")
            previousVC.distance = "20"
        case 3:
            println("Diesel segemnet clicked")
            previousVC.distance = "60"
        case 4:
            println("No Filter segemnet clicked")
            previousVC.distance = "99999"
        default:
            break;
        }  //Switch
    
    } // indexChanged for the Segmented Control
    
    @IBOutlet weak var ccSwitch: UISwitch!
    
    @IBAction func ccSelected(sender: AnyObject) {
        if ccSwitch.on {
            
            println("cc ON")
            previousVC.ccFilter = "1"
        }
        else{
            println("cc OFF")
            previousVC.ccFilter = "0"
        }
    }
    
    @IBOutlet weak var tfsSwitch: UISwitch!
    @IBAction func tfsSelected(sender: AnyObject) {
        if tfsSwitch.on {
            
            println("cc ON")
            previousVC.tfsFilter = "1"
        }
        else{
            println("cc OFF")
            previousVC.tfsFilter = "0"
        }
    }

    @IBOutlet weak var carwashSwitch: UISwitch!
    @IBAction func carwashSelected(sender: AnyObject) {
        if carwashSwitch.on {
            
            println("cc ON")
            carwashFilter = 1
        }
        else{
            println("cc OFF")
            carwashFilter = 0
        }
    }
    
    @IBOutlet var SortSC: UISegmentedControl!
    
    @IBAction func sortSelected(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            println("Price segement clicked")
            previousVC.sortBy = "Price"
            println("Set at: " + previousVC.sortBy)
        case 1:
            println("Distance segment clicked")
            previousVC.sortBy = "dist"
            println("Set at: " + previousVC.sortBy)
        default:
            break;
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
