//
//  ContactSearchViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactSearchViewController: UIViewController , Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{

    var pageIndex: Int = 1
    var pageSize: Int = 20
    var searchText: String = ""
    var dataRequestSource = ""
    var attachedURL = String()
     var hasAddedItemLine = false
    var selectedSuplier = Supplier?()
  
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var ContactTableView: UITableView!
    @IBOutlet weak var ContactSearchBox: UISearchBar!
    var supplierData = [Supplier]()
    
     weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    override func viewWillAppear(animated: Bool) {
        
        if hasAddedItemLine ==  true
        {
            Q6CommonLib.q6UIAlertPopupController("Information Message", message: "If changing the supplier, Please check the defaults are set correctly!", viewController: self ,timeArrange: 3)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        ContactSearchBox.delegate = self
        ContactTableView.delegate = self
        ContactTableView.dataSource = self
        Q6ActivityIndicatorView.startAnimating()
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        
  
        // Do any additional setup after loading the view.
    }
    func setControlAppear()
    {
        
        ContactSearchBox.layer.cornerRadius = 2;
         ContactSearchBox.layer.borderWidth = 0.1;
         ContactSearchBox.layer.borderColor = UIColor.blackColor().CGColor
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
        return supplierData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCellWithIdentifier("ContactSearchPrototypeCell", forIndexPath: indexPath) as! ContactSearchTableViewCell
        
        cell.lblSupplierID.hidden = true
        
      
           cell.lblSupplierName.text =  supplierData[indexPath.row].SupplierName
       
  cell.lblSupplierID.text =  supplierData[indexPath.row].SupplierID
      
        // Configure the cell...
        
        return cell
    }
    
    func setAttachedURL(SearchText: String , IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Search=" + SearchText + "&IsLoadInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(pageIndex)
    }
    
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                supplierData.removeAll()
               selectedSuplier = nil
            }
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["SupplierList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
      
            for i in 0  ..< returnData.count {
                
//                
//                print("no i =" + i.description)
           var dataItem = returnData[i]
                
                var supplier = Supplier()
                supplier.SupplierID = dataItem["SupplierID"] as! String
                
               // print("SupplierID" + supplier.SupplierID)
                
                supplier.SupplierName = dataItem["SupplierName"] as! String
              //   print("SupplierName" + supplier.SupplierName)

                
                supplier.DefaultPurchasesAccountID = dataItem["DefaultPurchasesAccountID"]  as? String
                
                
                 supplier.DefaultPurchasesTaxCodeID = dataItem["DefaultPurchasesTaxCodeID"]  as? String
                
                supplier.DefaultPurchasesAccountNameWithAccountNo = dataItem["DefaultPurchasesAccountNameWithAccountNo"] as? String
                
                 supplier.DefaultPurchasesTaxCodeName = dataItem["DefaultPurchasesTaxCodeName"] as! String
                
                
                  supplier.DefaultPurchasesTaxCodeRate = dataItem["DefaultPurchasesTaxCodeRate"] as! Double
                
                supplier.DefaultPurchasesTaxCodePurpose = dataItem["DefaultPurchasesTaxCodePurpose"] as! String
                
       
                
                if  supplier.DefaultPurchasesAccountNameWithAccountNo != nil {
                    
                    print(" supplier.DefaultPurchasesAccountNameWithAccountNO" +  supplier.DefaultPurchasesAccountNameWithAccountNo!)
                    
                }
                supplierData.append(supplier)
//                
//                printFields(purchasesTransactionListViewDataItem)
       }
            
            print("supplier Date Count" + supplierData.count.description)
    
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.ContactTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
                self.ContactSearchBox.resignFirstResponder()
                
            })


            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }
        
        return ""
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
          tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        print("selected indexpath" + indexPath.row.description)
          let  cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactSearchTableViewCell
        
     selectedSuplier = supplierData[indexPath.row]
        ContactSearchBox.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print("indexpath" + indexPath.row.description)
        if indexPath.row == pageIndex*(pageSize - 5 )
        {
            let q6CommonLib = Q6CommonLib(myObject: self)
            pageIndex++
            setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
            dataRequestSource = ""
             q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
        
            pageIndex = 1
            supplierData.removeAll()
          selectedSuplier = nil
            
            dataRequestSource = "Search"
       
           setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
          q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
            
        }
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
     
        pageIndex = 1
        supplierData.removeAll()
       selectedSuplier = nil
        
        dataRequestSource = "Search"
        setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        
        searchBar.resignFirstResponder()
        
    }
    @IBAction func CancelButtonClick(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
        
           // navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func DoneButtonClick(sender: AnyObject) {
     
        if selectedSuplier == nil {
            
            Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't select a supplier", viewController: self)
        }
        else{
        
            self.delegate?.sendGoBackFromContactSearchView("ContactSearchViewController" ,forCell :fromCell,Contact: selectedSuplier!)
//        
            
            navigationController?.popViewControllerAnimated(true)
   
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
