//
//  SaleDetailDataLineInventorySearchViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 14/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailDataLineInventorySearchViewController:UIViewController ,Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var InventoryListTableView: UITableView!
    @IBOutlet weak var InventorySearchBox: UISearchBar!
    // var preLoadInventoryPurchaseData = [PreLoadInventoryPurchase]()
    
    var inventoryViewData = [InventoryView]()
    @IBOutlet weak var Q6ActivityIndicator: UIActivityIndicatorView!
    
    var attachedStr = String()
    
    var fromCell = String()
    weak var delegate : Q6GoBackFromView?
    
    var dataRequestSource = ""
    
    var attachedURL = String()
    
    var pageIndex: Int = 1
    var pageSize: Int = 20
    var searchText: String = ""
    
    var selectedInventoryView = InventoryView?()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Q6ActivityIndicator.startAnimating()
        InventorySearchBox.delegate = self
        InventoryListTableView.delegate = self
        InventoryListTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        
        setAttachedURL("Sell",InventoryName: "" , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
        q6CommonLib.Q6IosClientGetApi("Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
        
        
    }
    
    
    func setAttachedURL(Property:String,InventoryName: String , IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Property=" + Property + "&InventoryName=" + InventoryName + "&IsIncludeInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(PageIndex)
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
        return inventoryViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCellWithIdentifier("InventoryCell", forIndexPath: indexPath) as! SaleDetailDataLineInventorySearchTableViewCell
        
        cell.lblInventoryName.text = inventoryViewData[indexPath.row].InventoryName
        cell.lblInventoryID.text = inventoryViewData[indexPath.row].InventoryID
        
        cell.lblInventoryID.hidden = true
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let  cell = tableView.cellForRowAtIndexPath(indexPath) as! SaleDetailDataLineInventorySearchTableViewCell
        
        selectedInventoryView = inventoryViewData[indexPath.row]
        InventorySearchBox.resignFirstResponder()
        
    }
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                inventoryViewData.removeAll()
                
                selectedInventoryView = nil
            }
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["InventoryTreeList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            
            for i in 0  ..< returnData.count {
                
                //                //
                //                //                print("no i =" + i.description)
                var dataItem = returnData[i]
                //
                var inventoryView = InventoryView()
                inventoryView.InventoryID = dataItem["InventoryID"] as! String
                
                inventoryView.InventoryName = dataItem["InventoryName"] as! String
                
                print("inventoryView.InventoryName " + inventoryView.InventoryName )
                
                inventoryView.IsBuy = dataItem["IsBuy"] as! Bool
                inventoryView.IsSell = dataItem["IsSell"] as! Bool
                inventoryView.IsInventory = dataItem["IsInventory"] as! Bool
                inventoryView.IsInactive = dataItem["IsInactive"] as! Bool
//                inventoryView.SupplierPartNumber = dataItem["SupplierPartNumber"] as! String
                
                var categoryName = dataItem["CategoryName"] as? String
                if categoryName != nil {
                    
                    
                    inventoryView.CategoryName = dataItem["CategoryName"] as! String
                    
                }
                else {
                    print("inventoryView.CategoryName nil")
                }
                
                var AssetAccountNameWithAccountNo = dataItem["AssetAccountNameWithAccountNo"] as? String
                
                if AssetAccountNameWithAccountNo != nil {
                    
                    inventoryView.AssetAccountNameWithAccountNo = AssetAccountNameWithAccountNo!
                    
                    
                    
                }
                inventoryView.SaleDescription = dataItem["SaleDescription"] as! String
                
                var SellingPrice = dataItem["SellingPrice"] as? Double
                
                if SellingPrice != nil {
                    inventoryView.SellingPrice = SellingPrice!
                    
                }
                else{
                    print("nil")
                }
                
                inventoryView.IsSalePriceTaxInclusive = dataItem["IsSalePriceTaxInclusive"] as! Bool
                
                
                inventoryView.SaleAccountNameWithAccountNo = dataItem["SaleAccountNameWithAccountNo"] as! String
                print("inventoryView.SaleAccountNameWithAccountNo" + inventoryView.SaleAccountNameWithAccountNo)
                
                inventoryView.SaleTaxCodeName = dataItem["SaleTaxCodeName"] as! String
                print("inventoryView.SaleTaxCodeName" + inventoryView.SaleTaxCodeName)
                
                
                inventoryView.SaleAccountNameWithAccountNo = dataItem["SaleAccountNameWithAccountNo"] as! String
                print("inventoryView.SaleAccountNameWithAccountNo" + inventoryView.SaleAccountNameWithAccountNo)
                
                var MinQuantityForRestockingAlert = dataItem["MinQuantityForRestockingAlert"] as? Double
                if MinQuantityForRestockingAlert != nil {
                    inventoryView.MinQuantityForRestockingAlert = MinQuantityForRestockingAlert!
                    
                    
                    
                }
                
                var QuantityOnHand = dataItem["QuantityOnHand"] as? Double
                
                if QuantityOnHand != nil {
                    
                    inventoryView.QuantityOnHand = QuantityOnHand!
                    
                }
                
                var CurrentValue = dataItem["CurrentValue"] as? Double
                
                if CurrentValue != nil {
                    
                    inventoryView.CurrentValue = CurrentValue!
                    print("inventoryView.CurrentValue" + inventoryView.CurrentValue.description)
                }
                
                var AverageCost = dataItem["AverageCost"] as? Double
                
                if AverageCost != nil {
                    
                    inventoryView.AverageCost = AverageCost!
                    
                }
                
                var Committed = dataItem["Committed"] as? Double
                
                if Committed != nil {
                    
                    inventoryView.Committed = Committed!
                    
                }
                
                var OnOrder = dataItem["OnOrder"] as? Double
                
                if OnOrder != nil {
                    
                    inventoryView.OnOrder = OnOrder!
                    print("inventoryView.OnOrder" + inventoryView.OnOrder.description)
                }
                
                var Available = dataItem["Available"] as? Double
                if Available != nil {
                    
                    inventoryView.Available = Available!
                    print("inventoryView.Available" + inventoryView.Available.description)
                }
                
                
                var AssetAccountID = dataItem["AssetAccountID"] as? String
                if AssetAccountID != nil {
                    
                    inventoryView.AssetAccountID = AssetAccountID!
                    print("inventoryView.AssetAccountID " + inventoryView.AssetAccountID! )
                }
                
//                var SaleAccountID = dataItem["SaleAccountID"] as? String
//                if PurchaseAccountID != nil {
//                    
//                    inventoryView.SaleAccountID = SaleAccountID!
//                    print("inventoryView.SaleAccountID " + inventoryView.SaleAccountID! )
//                }
                
                var SaleAccountID = dataItem["SaleAccountID"] as? String
                if SaleAccountID != nil {
                    
                    inventoryView.SaleAccountID = SaleAccountID!
                    print("inventoryView.SaleAccountID " + inventoryView.SaleAccountID! )
                }
                
                
//                var PurchaseTaxCodeID = dataItem["PurchaseTaxCodeID"] as? String
//                if PurchaseTaxCodeID != nil {
//                    
//                    inventoryView.PurchaseTaxCodeID = PurchaseTaxCodeID!
//                    print("inventoryView.PurchaseTaxCodeID " + inventoryView.PurchaseTaxCodeID! )
//                }
                
                var SaleTaxCodeRate = dataItem["SaleTaxCodeRate"] as? Double
                if SaleTaxCodeRate != nil {
                    
                    inventoryView.SaleTaxCodeRate = SaleTaxCodeRate!
                    print("inventoryView.SaleTaxCodeRate " + inventoryView.SaleTaxCodeRate!.description )
                }
                
                var SaleTaxCodePurpose = dataItem["SaleTaxCodePurpose"] as? String
                if SaleTaxCodePurpose != nil {
                    
                    inventoryView.SaleTaxCodePurpose = SaleTaxCodePurpose!
                    print("inventoryView.SaleTaxCodePurpose " + inventoryView.SaleTaxCodePurpose! )
                }
                
                inventoryViewData.append(inventoryView )
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            pageIndex = 1
            inventoryViewData.removeAll()
            
            
            dataRequestSource = "Search"
            
            setAttachedURL("Sell",InventoryName: searchText , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
            q6CommonLib.Q6IosClientGetApi("Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
            
        }
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        inventoryViewData.removeAll()
        //  purchaseTransactionListData.removeAll()
        
        dataRequestSource = "Search"
        //  print("purchaseTransactionListdata count" + purchaseTransactionListData.count.description)
        if InventorySearchBox.text?.length > 0 {
            
            var inventoryName = self.InventorySearchBox.text!
            
            pageIndex = 1
            inventoryViewData.removeAll()
            setAttachedURL("Sell",InventoryName: inventoryName , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
            q6CommonLib.Q6IosClientGetApi("Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
        }
        
        searchBar.resignFirstResponder()
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print("indexpath" + indexPath.row.description)
        if indexPath.row == pageIndex*(pageSize - 5 )
        {
            let q6CommonLib = Q6CommonLib(myObject: self)
            pageIndex++
            // setAttachedURL(searchText, PageSize: pageSize, PageIndex: pageIndex)
            dataRequestSource = ""
            //q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsList", attachedURL: attachedURL)
            
            setAttachedURL("Sell",InventoryName: searchText , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
            q6CommonLib.Q6IosClientGetApi("Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
        }
        
    }
    
    @IBAction func CancelButtonClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        if selectedInventoryView != nil {
            
            //  self.delegate?.sendGoBackFromContactSearchView("ContactSearchViewController" ,forCell :fromCell,Contact: selectedSuplier!)
            self.delegate?.sendGoBackFromSaleDetailDataLineInventorySearchView("SaleDetailDataLineInventorySearchViewController", forCell: "InventoryCell", inventoryView: selectedInventoryView!)
            navigationController?.popViewControllerAnimated(true)
        }
        else{
            Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't select a Inventory", viewController: self)
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
