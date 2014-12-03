//
//  signupVC.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 10/21/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet var newFirstName: UITextField!
    @IBOutlet var newLastName: UITextField!
    @IBOutlet var newEmail: UITextField!
    @IBOutlet var newUsername: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var newPasswordCheck: UITextField!
    
    @IBAction func backToLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupTriggered(sender: AnyObject) {
        
        if (newFirstName.text == "" || newLastName.text == ""
            || newUsername.text == "" || newPassword.text == "" || newEmail.text == "")
        {
            var alert:UIAlertView = UIAlertView()
            alert.title = "Error"
            alert.message = "Please fill in all cells"
            alert.delegate = self
            alert.addButtonWithTitle("Dismiss")
            alert.show()
            
            newPassword.text = ""
            newPasswordCheck.text = ""
        }
        else if (newPassword.text != newPasswordCheck.text)
        {
            var alert:UIAlertView = UIAlertView()
            alert.title = "Error"
            alert.message = "Password does not match!"
            alert.delegate = self
            alert.addButtonWithTitle("Dismiss")
            alert.show()
        
            newPassword.text = ""
            newPasswordCheck.text = ""
        }
        else
        {
            var post:NSString = "username=" + newUsername.text + "&password=" + newPassword.text + "&firstname=" + newFirstName.text + "&lastname=" + newLastName.text + "&email=" + newEmail.text
            
            NSLog("post: %@", post)
            var url:NSURL = NSURL(string:"http://shopbuddyucr.com/newuser.php")!
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
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }
            else {
                var alert:UIAlertView = UIAlertView()
                alert.title = "Error"
                alert.message = "Connection failed..."
                alert.delegate = self
                alert.addButtonWithTitle("Dismiss")
                alert.show()
            }
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
