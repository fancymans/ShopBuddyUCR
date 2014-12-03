//
//  ProductsCatalogVC.swift
//  ShopBuddy
//
//  Created by Kenneth Hsu on 11/17/14.
//  Copyright (c) 2014 Fancy. All rights reserved.
//

import UIKit

class ProductsCatalogVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var catalogTable: UITableView!
    @IBOutlet var productSearchBar: UISearchBar!
    
    var previousVC: ShoppingListVC = ShoppingListVC()
    var arrayOfProducts = [Product] ()
    var filteredProducts = [Product] ()
    
    
    var isFiltered = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.catalogTable.delegate = self
        self.catalogTable.dataSource = self
        
        self.productSearchBar.delegate = self
        
        loadCatalog()
        
        catalogTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered {
            return filteredProducts.count
        }
        else {
            return arrayOfProducts.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ProductCell = tableView.dequeueReusableCellWithIdentifier("catalogItem") as ProductCell
        let currentProduct = arrayOfProducts[indexPath.row]
        // cell.setCell(currentProduct.category, productName: currentProduct.productName, isProduct:currentProduct.isProduct)
        
        if isFiltered {
            let currentFilteredProduct = filteredProducts[indexPath.row]

            cell.setCell(currentFilteredProduct.category, productName: currentFilteredProduct.productName, isProduct:currentFilteredProduct.isProduct)
        }
        else {
            cell.setCell(currentProduct.category, productName: currentProduct.productName, isProduct:currentProduct.isProduct)
        }
        
        return cell
    }
    
    @IBAction func cancelTriggered(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
//        println("searchbar called")
        if (countElements(searchText) == 0)
        {
            //set our boolean flag
            isFiltered = false
//            println("isFiltered is false")
        }
        else
        {
            //set our boolean flag
            isFiltered = true
            //empty filteredProducts
            filteredProducts = []
            
            // var stringString : String
            
//            println("before enumer")
            //fast enumerate
            for var i = 0; i < arrayOfProducts.count; i++ {
                
                //compare and plug into filtered
//                println((i))
//                println((arrayOfProducts[i].productName))
////                println("searchText:", (searchText))
                
                var stringMatch = arrayOfProducts[i].productName.lowercaseString.rangeOfString(searchText)
                var stringMatch2 = arrayOfProducts[i].productName.rangeOfString(searchText)
                var stringMatch3 = arrayOfProducts[i].productName.uppercaseString.rangeOfString(searchText)
//                println("stringMatch:")
//                println(stringMatch)
//                println("productname")
//                println(arrayOfProducts[i].productName)
                
                if (stringMatch != nil) || (stringMatch2 != nil) || (stringMatch3 != nil) {
                    var newCategory : String = arrayOfProducts[i].category
                    var newProduct : String = arrayOfProducts[i].productName
                    
                    filteredProducts.append(Product(category: newCategory, productName: newProduct))
                }
                
                
            }
//            println("after enusmer")
        }
        //reload data
        catalogTable.reloadData()
    }
    
    func setPrevVC (prevVC: ShoppingListVC) {
        previousVC = prevVC
    }

    func loadCatalog () {
        arrayOfProducts.append(Product(category: "Gas", productName: ""))
        arrayOfProducts.append(Product(category: "Gas", productName: "Regular Gas"))
        arrayOfProducts.append(Product(category: "Gas", productName: "Price87"))
        arrayOfProducts.append(Product(category: "Gas", productName: "Price89"))
        arrayOfProducts.append(Product(category: "Gas", productName: "Price91"))
        arrayOfProducts.append(Product(category: "Gas", productName: "PriceD"))
        arrayOfProducts.append(Product(category: "Gas", productName: "Mid-grade Gas"))
        arrayOfProducts.append(Product(category: "Gas", productName: "Diesel Gas"))
        
        arrayOfProducts.append(Product(category: "Fruit", productName: ""))
        arrayOfProducts.append(Product(category: "Fruit", productName: "Apple"))
        arrayOfProducts.append(Product(category: "Fruit", productName: "Orange"))
        arrayOfProducts.append(Product(category: "Fruit", productName: "Banana"))
        arrayOfProducts.append(Product(category: "Fruit", productName: "Watermelon"))
        
        arrayOfProducts.append(Product(category: "Electronic", productName: ""))
        arrayOfProducts.append(Product(category: "Electronic", productName: "iPhone 6"))
        arrayOfProducts.append(Product(category: "Electronic", productName: "iPad Air 2"))
        arrayOfProducts.append(Product(category: "Electronic", productName: "Lightning Cable"))
        arrayOfProducts.append(Product(category: "Electronic", productName: "AirPort Express"))
    
        arrayOfProducts.append(Product(category: "Beverage", productName: ""))
        arrayOfProducts.append(Product(category: "Beverage", productName: "Coca-Cola"))
        arrayOfProducts.append(Product(category: "Beverage", productName: "Bud Light"))
        arrayOfProducts.append(Product(category: "Beverage", productName: "Water"))
        arrayOfProducts.append(Product(category: "Beverage", productName: "Orange Juice"))

        arrayOfProducts.append(Product(category: "Cleaning", productName: ""))
        arrayOfProducts.append(Product(category: "Cleaning", productName: "Windex"))
        arrayOfProducts.append(Product(category: "Cleaning", productName: "Clorex"))

        arrayOfProducts.append(Product(category: "Cloth", productName: ""))
        arrayOfProducts.append(Product(category: "Cloth", productName: "T-Shirt"))
        arrayOfProducts.append(Product(category: "Cloth", productName: "Jeans"))
        arrayOfProducts.append(Product(category: "Cloth", productName: "Swimsuit"))
    }
    
    func filterContentForSearchText(searchText: String) {
        println("filterContentForSearchText called")
        // Filter the array using the filter method
        self.filteredProducts = self.arrayOfProducts.filter({( product: Product) -> Bool in
            let stringMatch = product.productName.rangeOfString(searchText)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("You selected custom cell #: " + String(format: "%i", indexPath.row))
        
        if (isFiltered == true){
            if filteredProducts[indexPath.row].isProduct {
                previousVC.queryText = filteredProducts[indexPath.row].productName
                
                println("queryText: " + previousVC.queryText)
                previousVC.arrayOfShoppingItems.append(previousVC.queryText)
            }
        }
            
        else{
            if arrayOfProducts[indexPath.row].isProduct {
                previousVC.queryText = arrayOfProducts[indexPath.row].productName
                
                println("queryText: " + previousVC.queryText)
                previousVC.arrayOfShoppingItems.append(previousVC.queryText)
            }
        }
        
        
        previousVC.viewDidLoad()
        
        self.dismissViewControllerAnimated(true, completion: nil)
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

