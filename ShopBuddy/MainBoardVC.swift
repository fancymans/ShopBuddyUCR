//
//  MainBoardVC.swift
//  ShopBuddy
//
//  Created by Darrin Lin on 11/8/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class MainBoardVC: UITabBarController {

    var segueIndex: Int = 0
    var queryRequestText: String = "default"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if segueIndex != 0 {
            self.selectedIndex = segueIndex
            if queryRequestText != "default" {
                var tmpVC: SearchVC = self.selectedViewController as SearchVC
                tmpVC.productSearchBar.text = queryRequestText
                tmpVC.getCurrentLocation();
            }
        }
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
