//
//  Details.swift
//  ShopBuddy
//
//  Created by Darrin Lin on 11/12/14.
//  Copyright (c) 2014 Kenneth Hsu. All rights reserved.
//

import UIKit

class Details: UIViewController, UITextFieldDelegate {
    
    var previousVC: SearchVC = SearchVC()
    var detailProduct: Product!
    var url: NSURL = NSURL(string: "http://shopbuddyucr.com/SubmitPrice.php")!
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var businessName: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var phoneNum: UILabel!
    @IBOutlet var productName: UILabel!
    @IBOutlet var productPrice: UITextField!
    @IBOutlet var user: UILabel!
    @IBOutlet var time: UILabel!
    
    
    
    @IBAction func updatePrices(sender: AnyObject) {
        // detailProduct.productPrice = productPrice.text
        sendPricesToPHP()
    }
    
    @IBAction func doneTriggered(sender: AnyObject) {
        println("going back to results")
        self.dismissViewControllerAnimated(true, completion: nil)
        previousVC.viewDidLoad()
    }
    
    override func viewDidLoad() {
        self.setCurrentProduct()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Business().getListOfBusinesses()
        self.productPrice.delegate = self
        
        self.setLabels()
//        self.navigationController?.navigationBarHidden = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Dismiss keyboard when user presses return
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setCurrentProduct() {
        detailProduct = previousVC.currentProduct
    }
    
    func setLabels () {
        println("setting labels")
        var tmpListOfBusinesses: [Business] = Business().getListOfBusinesses()
        var tmpBusiness: Business = detailProduct.getBusiness(tmpListOfBusinesses)
        
        image.image = UIImage(named: "sampleBusinessPhoto.png")
        productName.text = detailProduct.productName
        businessName.text = detailProduct.businessName
        phoneNum.text = tmpBusiness.phoneNum
        address.text = tmpBusiness.address
        productPrice.text = "$" + detailProduct.productPrice
        
    }
    
    func sendPricesToPHP() {
        // Formatting lati and long into NSStrings to send
        var bID: NSString = detailProduct.businessID
        var pID: NSString = detailProduct.productID
        var price: NSString = NSString(format: productPrice.text)
        var user: NSString = NSString(format: "Darrin")
        println("myID: " + detailProduct.productID)
        var post: NSString = NSString(format: "ID=" + pID + "&Price=" + price + "&User=" + user)
        println(post)
        
        var postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength: NSString = String( postData.length )
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
        
        if (urlData != nil) {
            var responseData:NSString = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
            NSLog("Response ==> %@", responseData);
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
