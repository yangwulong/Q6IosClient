//
//  PreLoadInventoryPurchaseViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 12/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailDataLineInventorySearchViewController:UIViewController ,Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{
    
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
   
    var selectedInventoryView:InventoryView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Q6ActivityIndicator.startAnimating()
        InventorySearchBox.delegate = self
        InventoryListTableView.delegate = self
        InventoryListTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        
        setAttachedURL(Property: "Buy",InventoryName: "" , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
        q6CommonLib.Q6IosClientGetApi(ModelName: "Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
        
        
    }
    
    
    func setAttachedURL(Property:String,InventoryName: String , IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Property=" + Property + "&InventoryName=" + InventoryName + "&IsIncludeInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(PageIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! PurchaseDetailDataLineInventorySearchTableViewCell
        
        cell.lblInventoryName.text = inventoryViewData[indexPath.row].InventoryName
        cell.lblInventoryID.text = inventoryViewData[indexPath.row].InventoryID
        
        cell.lblInventoryID.isHidden = true
        
        // Configure the cell...
        
        return cell
    }
    
    func tableView(_ didSelectRowAttableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       // let  cell = tableView.cellForRowAtIndexPath(indexPath) as! PurchaseDetailDataLineInventorySearchTableViewCell
        
       selectedInventoryView = inventoryViewData[indexPath.row]
        InventorySearchBox.resignFirstResponder()
  
    }
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                inventoryViewData.removeAll()
                
            selectedInventoryView = nil
            }
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["InventoryTreeList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            
            for i in 0  ..< returnData.count {
                
                //                //
                //                //                print("no i =" + i.description)
                var dataItem = returnData[i]
                //
             let inventoryView = InventoryView()
                inventoryView.InventoryID = dataItem["InventoryID"] as! String
                
                inventoryView.InventoryName = dataItem["InventoryName"] as! String
                
               print("inventoryView.InventoryName " + inventoryView.InventoryName )
                
                inventoryView.IsBuy = dataItem["IsBuy"] as! Bool
                inventoryView.IsSell = dataItem["IsSell"] as! Bool
                inventoryView.IsInventory = dataItem["IsInventory"] as! Bool
                inventoryView.IsInactive = dataItem["IsInactive"] as! Bool
                inventoryView.SupplierPartNumber = dataItem["SupplierPartNumber"] as! String
                
                let categoryName = dataItem["CategoryName"] as? String
                if categoryName != nil {
                    
             
                inventoryView.CategoryName = dataItem["CategoryName"] as! String
                    
                }
                else {
                    print("inventoryView.CategoryName nil")
                }
     
                let AssetAccountNameWithAccountNo = dataItem["AssetAccountNameWithAccountNo"] as? String
                
                if AssetAccountNameWithAccountNo != nil {
                    
                    inventoryView.AssetAccountNameWithAccountNo = AssetAccountNameWithAccountNo!
                    
                   
                    
                }
                inventoryView.PurchaseDescription = dataItem["PurchaseDescription"] as! String
                
                let PurchasePrice = dataItem["PurchasePrice"] as? Double
                
                if PurchasePrice != nil {
                    inventoryView.PurchasePrice = PurchasePrice!
                   
                }
                else{
                    print("nil")
                }
                
              inventoryView.IsPurchasePriceTaxInclusive = dataItem["IsPurchasePriceTaxInclusive"] as! Bool
           
                
                inventoryView.PurchaseAccountNameWithAccountNo = dataItem["PurchaseAccountNameWithAccountNo"] as! String
                print("inventoryView.PurchaseAccountNameWithAccountNo" + inventoryView.PurchaseAccountNameWithAccountNo)
                
                inventoryView.PurchaseTaxCodeName = dataItem["PurchaseTaxCodeName"] as! String
                print("inventoryView.PurchaseTaxCodeName" + inventoryView.PurchaseTaxCodeName)
                
             
                inventoryView.PurchaseAccountNameWithAccountNo = dataItem["PurchaseAccountNameWithAccountNo"] as! String
                print("inventoryView.PurchaseAccountNameWithAccountNo" + inventoryView.PurchaseAccountNameWithAccountNo)
                
                let MinQuantityForRestockingAlert = dataItem["MinQuantityForRestockingAlert"] as? Double
                if MinQuantityForRestockingAlert != nil {
                    inventoryView.MinQuantityForRestockingAlert = MinQuantityForRestockingAlert!
                    
            
                    
                }
                
                let QuantityOnHand = dataItem["QuantityOnHand"] as? Double
                
                if QuantityOnHand != nil {
                    
                    inventoryView.QuantityOnHand = QuantityOnHand!
                 
                }
                
                let CurrentValue = dataItem["CurrentValue"] as? Double
                
                if CurrentValue != nil {
                    
                    inventoryView.CurrentValue = CurrentValue!
                    print("inventoryView.CurrentValue" + inventoryView.CurrentValue.description)
                }
                
                let AverageCost = dataItem["AverageCost"] as? Double
                
                if AverageCost != nil {
                    
                    inventoryView.AverageCost = AverageCost!
                   
                }
                
                let Committed = dataItem["Committed"] as? Double
                
                if Committed != nil {
                    
                    inventoryView.Committed = Committed!
                 
                }
                
                let OnOrder = dataItem["OnOrder"] as? Double
                
                if OnOrder != nil {
                    
                    inventoryView.OnOrder = OnOrder!
                    print("inventoryView.OnOrder" + inventoryView.OnOrder.description)
                }
                
                let Available = dataItem["Available"] as? Double
                 if Available != nil {
                    
                    inventoryView.Available = Available!
                    print("inventoryView.Available" + inventoryView.Available.description)
                }
                
                
                let AssetAccountID = dataItem["AssetAccountID"] as? String
                if AssetAccountID != nil {
                    
                    inventoryView.AssetAccountID = AssetAccountID!
                    print("inventoryView.AssetAccountID " + inventoryView.AssetAccountID! )
                }
                
                let PurchaseAccountID = dataItem["PurchaseAccountID"] as? String
                if PurchaseAccountID != nil {
                    
                    inventoryView.PurchaseAccountID = PurchaseAccountID!
                    print("inventoryView.PurchaseAccountID " + inventoryView.PurchaseAccountID! )
                }
                
                let SaleAccountID = dataItem["SaleAccountID"] as? String
                if SaleAccountID != nil {
                    
                    inventoryView.SaleAccountID = SaleAccountID!
                    print("inventoryView.SaleAccountID " + inventoryView.SaleAccountID! )
                }
                
                
                let PurchaseTaxCodeID = dataItem["PurchaseTaxCodeID"] as? String
                if PurchaseTaxCodeID != nil {
                    
                    inventoryView.PurchaseTaxCodeID = PurchaseTaxCodeID!
                    print("inventoryView.PurchaseTaxCodeID " + inventoryView.PurchaseTaxCodeID! )
                }
                
                let PurchaseTaxCodeRate = dataItem["PurchaseTaxCodeRate"] as? Double
                if PurchaseTaxCodeRate != nil {
                    
                    inventoryView.PurchaseTaxCodeRate = PurchaseTaxCodeRate!
                    print("inventoryView.PurchaseTaxCodeRate " + inventoryView.PurchaseTaxCodeRate!.description )
                }
                
                let PurchaseTaxCodePurpose = dataItem["PurchaseTaxCodePurpose"] as? String
                if PurchaseTaxCodePurpose != nil {
                    
                    inventoryView.PurchaseTaxCodePurpose = PurchaseTaxCodePurpose!
                    print("inventoryView.PurchaseTaxCodePurpose " + inventoryView.PurchaseTaxCodePurpose! )
                }
                
                inventoryViewData.append(inventoryView )
                //
                //         printFields(purchasesTransactionListViewDataItem)
            }
            
            //            print("supplier Date Count" + supplierData.count.description)
            //
            
              inventoryViewData = inventoryViewData.sorted{$0.InventoryName < $1.InventoryName}
            
          DispatchQueue.main.async {
                self.InventoryListTableView.reloadData()
                self.Q6ActivityIndicator.hidesWhenStopped = true
                self.Q6ActivityIndicator.stopAnimating()
                self.InventorySearchBox.resignFirstResponder()
            
            }
            
            
            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return "" as AnyObject
        }
        
        return "" as AnyObject
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            pageIndex = 1
           inventoryViewData.removeAll()
          
            
            dataRequestSource = "Search"
            
            setAttachedURL(Property: "Buy",InventoryName: searchText , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
            q6CommonLib.Q6IosClientGetApi(ModelName: "Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
            
        }
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        inventoryViewData.removeAll()
        //  purchaseTransactionListData.removeAll()
        
        dataRequestSource = "Search"
        //  print("purchaseTransactionListdata count" + purchaseTransactionListData.count.description)
        if (InventorySearchBox.text?.length)! > 0 {
            
            let inventoryName = self.InventorySearchBox.text!
           
            pageIndex = 1
            inventoryViewData.removeAll()
            setAttachedURL(Property: "Buy",InventoryName: inventoryName , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
            q6CommonLib.Q6IosClientGetApi(ModelName: "Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
        }
        
        searchBar.resignFirstResponder()
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexpath" + indexPath.row.description)
        if indexPath.row == pageIndex*(pageSize - 5 )
        {
            let q6CommonLib = Q6CommonLib(myObject: self)
            pageIndex = pageIndex + 1
           // setAttachedURL(searchText, PageSize: pageSize, PageIndex: pageIndex)
            dataRequestSource = ""
            //q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsList", attachedURL: attachedURL)
            
            setAttachedURL(Property: "Buy",InventoryName: searchText , IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex )
            q6CommonLib.Q6IosClientGetApi(ModelName: "Item", ActionName: "GetInventoryListView", attachedURL: attachedURL)
        }
        
    }
    
    @IBAction func CancelButtonClicked(sender: AnyObject) {
           _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        if selectedInventoryView != nil {
            
           //  self.delegate?.sendGoBackFromContactSearchView("ContactSearchViewController" ,forCell :fromCell,Contact: selectedSuplier!)
            self.delegate?.sendGoBackFromPurchaseDetailDataLineInventorySearchView(fromView: "PurchaseDetailDataLineInventorySearchViewController", forCell: "InventoryCell", inventoryView: selectedInventoryView!)
               _ = navigationController?.popViewController(animated: true)
        }
        else{
              Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "You haven't select a Inventory", viewController: self)
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
