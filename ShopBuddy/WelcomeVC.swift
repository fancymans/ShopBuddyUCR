//
//  ViewController.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 10/20/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
//    var instanceOfLogin : LoginVC = LoginVC()
//    @IBOutlet var usernameLabel: UILabel!
    var isLoggedIn : Int = 0
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        prefs.setInteger(isLoggedIn, forKey: "isLoggedIn")
        prefs.synchronize()
        
        let loggedOn = prefs.integerForKey("isLoggedIn") as Int
        if (loggedOn == 0) {
            self.performSegueWithIdentifier("goto_Login", sender: self)
        }
        else {
            sleep(1)
            self.performSegueWithIdentifier("goto_mainBoard", sender: self)
        }
    }
}

