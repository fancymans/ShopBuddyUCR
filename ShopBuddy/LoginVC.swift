//
//  loginVC.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 10/21/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    var prefs = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prefs.setInteger(0, forKey: "isLoggedIn")
        prefs.setObject("", forKey: "currentUserName")
        prefs.synchronize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTriggered(sender: AnyObject) {
        
        if (username.text == "" || password.text == "")
        {
            var alert:UIAlertView = UIAlertView()
            alert.title = "Sign in Failed!"
            alert.message = "Username or password field is empty. Please enter both username and password to login."
            alert.delegate = self
            alert.addButtonWithTitle("Dismiss")
            alert.show()
            
            username.text == ""
            password.text == ""
        }
        else
        {
            var post:NSString = "username=" + username.text + "&password=" + password.text
            NSLog("post: %@", post)
            var url:NSURL = NSURL(string:"http://shopbuddyucr.com/login.php")!
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String( postData.length )
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            var reponseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
            if (urlData != nil) {
                var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
            
                if (responseData == "TRUE") {
                    prefs.setInteger(1, forKey: "isLoggedIn")
                    prefs.setObject(username.text, forKey: "currentUserName")
                    prefs.synchronize()
                    self.performSegueWithIdentifier(
                        "goto_mainBoard", sender: self)
                } else {
                    var alert:UIAlertView = UIAlertView()
                    alert.title = "Error"
                    alert.message = "Username or password is incorrect."
                    alert.delegate = self
                    alert.addButtonWithTitle("Dismiss")
                    alert.show()
                }
            }
            else {
                var alert:UIAlertView = UIAlertView()
                alert.title = "Error"
                alert.message = "Connection Failed."
                alert.delegate = self
                alert.addButtonWithTitle("Dismiss")
                alert.show()
            }
        }
    }

}
