//
//  PreLoadInventoryPurchaseViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 12/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PreLoadInventoryPurchaseViewController:UIViewController ,Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var InventoryListTableView: UITableView!
    @IBOutlet weak var InventorySearchBox: UISearchBar!
    var preLoadInventoryPurchaseData = [PreLoadInventoryPurchase]()
    
    @IBOutlet weak var Q6ActivityIndicator: UIActivityIndicatorView!
    
    var attachedStr = String()
    
    var fromCell = String()
    weak var delegate : Q6GoBackFromView?
    
    var dataRequestSource = ""
    var selectedInventoryID = String?()
    var selectedInventoryName = String?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Q6ActivityIndicator.startAnimating()
        InventorySearchBox.delegate = self
        InventoryListTableView.delegate = self
        InventoryListTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        
        attachedStr = "&JsonPreLoad={\"PreLoadField\":{\"PreLoadActiveInventoryList\":\"\"}}"
        q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "PreLoadFields_Purchase", attachedURL: attachedStr)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preLoadInventoryPurchaseData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCellWithIdentifier("InventoryCell", forIndexPath: indexPath) as! PreLoadInventoryPurchaseTableViewCell
        
        cell.lblInventoryName.text = preLoadInventoryPurchaseData[indexPath.row].InventoryName
        cell.lblInventoryID.text = preLoadInventoryPurchaseData[indexPath.row].InventoryID
        
        cell.lblInventoryID.hidden = true
        
        // Configure the cell...
        
        return cell
    }
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                preLoadInventoryPurchaseData.removeAll()
                
                selectedInventoryID = nil
                selectedInventoryName = nil
            }
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["PreLoadInventoryList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            
            for i in 0  ..< returnData.count {
                
                //                //
                //                //                print("no i =" + i.description)
                var dataItem = returnData[i]
                //
                var preLoadInventoryPurchase = PreLoadInventoryPurchase()
                preLoadInventoryPurchase.InventoryID = dataItem["InventoryID"] as! String
                
                
                //print("preLoadInventoryPurchase.InventoryID " + preLoadInventoryPurchase.InventoryID )
                
                preLoadInventoryPurchase.InventoryName = dataItem["InventoryName"] as! String
                print("preLoadInventoryPurchase.InventoryName" + preLoadInventoryPurchase.InventoryName )
                preLoadInventoryPurchase.TaxCodeName = dataItem["TaxCodeName"] as! String
                // print("preLoadInventoryPurchase.TaxCodeName" + preLoadInventoryPurchase.TaxCodeName )
                
                preLoadInventoryPurchase.TaxRate = dataItem["TaxRate"] as! Double
                //print("preLoadInventoryPurchase.TaxRate" + preLoadInventoryPurchase.TaxRate.description )
                
                preLoadInventoryPurchase.Description = dataItem["Description"] as! String
                // print("preLoadInventoryPurchase.Description" + preLoadInventoryPurchase.Description)
                
                preLoadInventoryPurchase.AccountID = dataItem["AccountID"] as! String
                //print("preLoadInventoryPurchase.AccountID" + preLoadInventoryPurchase.AccountID)
                
                preLoadInventoryPurchase.IsPurchasePriceTaxInclusive = dataItem["IsPurchasePriceTaxInclusive"] as! Bool
                //   print("preLoadInventoryPurchase.ISPurchasePriceTaxInclusive" + preLoadInventoryPurchase.IsPurchasePriceTaxInclusive.description)
                
                preLoadInventoryPurchase.PurchasePrice = dataItem["PurchasePrice"] as! Double
                print("preLoadInventoryPurchase.PurchasePrice " + preLoadInventoryPurchase.PurchasePrice.description)
                //                supplier.SupplierID = dataItem["SupplierID"] as! String
                //
                //                print("SupplierID" + supplier.SupplierID)
                //
                //                supplier.SupplierName = dataItem["SupplierName"] as! String
                //                print("SupplierName" + supplier.SupplierName)
                //
                //
                preLoadInventoryPurchaseData.append(preLoadInventoryPurchase )
                //
                //         printFields(purchasesTransactionListViewDataItem)
            }
            
            //            print("supplier Date Count" + supplierData.count.description)
            //
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.InventoryListTableView.reloadData()
                self.Q6ActivityIndicator.hidesWhenStopped = true
                self.Q6ActivityIndicator.stopAnimating()
                self.InventorySearchBox.resignFirstResponder()
                
            })
            
            
            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }
        
        return ""
    }
    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        preLoadInventoryPurchaseData.removeAll()
        //  purchaseTransactionListData.removeAll()
        
        dataRequestSource = "Search"
        //  print("purchaseTransactionListdata count" + purchaseTransactionListData.count.description)
        if InventorySearchBox.text?.length > 0 {
            
            self.attachedStr = "&InventoryType=IsBuy&InventoryName=" + self.InventorySearchBox.text!
            q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "PreLoadFields_Purchase", attachedURL: attachedStr)
        }
        
        searchBar.resignFirstResponder()
        
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
