//
//  AboutMeVC.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 10/31/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class AboutMeVC: UIViewController {
    
    @IBAction func logoutTriggered(sender: AnyObject) {
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(0, forKey: "isLoggedIn")
        prefs.synchronize()
        
        self.performSegueWithIdentifier("goto_Login", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
