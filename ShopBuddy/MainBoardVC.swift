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
    var currentUser: User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Current Username: " + currentUser.username)
        // Do any additional setup after loading the view.
        if segueIndex == 0 {
            self.selectedIndex = segueIndex
            var tmpVC: FeaturedVC = self.selectedViewController as FeaturedVC
            tmpVC.currentUserName = currentUser.username
        }
        if segueIndex == 1 {
            self.selectedIndex = segueIndex
            if queryRequestText != "default" {
                var tmpVC: SearchVC = self.selectedViewController as SearchVC
                tmpVC.productSearchBar.text = queryRequestText
                tmpVC.getCurrentLocation();
                tmpVC.busyIndicator.startAnimating()
                tmpVC.currentUserName = currentUser.username
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentUser(newUser: User) {
        currentUser = newUser
        println("Set current user to: " + currentUser.username)
        self.viewDidLoad()
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
