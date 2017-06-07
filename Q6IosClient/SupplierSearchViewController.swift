//
//  SupplierSearchViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SupplierSearchViewController: UIViewController , Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{

    var pageIndex: Int = 1
    var pageSize: Int = 20
    var searchText: String = ""
    var dataRequestSource = ""
    var attachedURL = String()
     var hasAddedItemLine = false
    var selectedSuplier:Supplier?
  
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var ContactTableView: UITableView!
    @IBOutlet weak var ContactSearchBox: UISearchBar!
    var supplierData = [Supplier]()
    
     weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if hasAddedItemLine ==  true
        {
            Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "If changing the supplier, Please check the defaults are set correctly!", viewController: self ,timeArrange: 3)
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
        
        setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi(ModelName: "Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        
  
        // Do any additional setup after loading the view.
    }
    func setControlAppear()
    {
        
        ContactSearchBox.layer.cornerRadius = 2;
         ContactSearchBox.layer.borderWidth = 0.1;
         ContactSearchBox.layer.borderColor = UIColor.black.cgColor
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
        return supplierData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "SupplierSearchPrototypeCell", for: indexPath) as! SupplierSearchTableViewCell
        
        cell.lblSupplierID.isHidden = true
        
      
        cell.lblSupplierName.text =  supplierData[indexPath.row].SupplierName
       
        cell.lblSupplierID.text =  supplierData[indexPath.row].SupplierID
      
        // Configure the cell...
        
        return cell
    }
    
    func setAttachedURL(SearchText: String , IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Search=" + SearchText + "&IsLoadInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(pageIndex)
    }
    
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                supplierData.removeAll()
               selectedSuplier = nil
            }
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["SupplierList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            
            print(returnData[0])
            for i in 0  ..< returnData.count {
                
                var dataItem = returnData[i]
                let supplier = Supplier()
                supplier.SupplierID = dataItem["SupplierID"] as! String
                
                supplier.SupplierName = dataItem["SupplierName"] as! String

                
                supplier.DefaultPurchasesAccountID = dataItem["DefaultPurchasesAccountID"]  as? String
                
                
                supplier.DefaultPurchasesTaxCodeID = dataItem["DefaultPurchasesTaxCodeID"]  as? String
                
                supplier.DefaultPurchasesAccountNameWithAccountNo = dataItem["DefaultPurchasesAccountNameWithAccountNo"] as? String
                
                supplier.DefaultPurchasesTaxCodeName = dataItem["DefaultPurchasesTaxCodeName"] as! String
                
                if let defaultDueDate = dataItem["DefaultDueDate"], let defaultDueDateOption = dataItem["DefaultDueDateOption"] {
                    
                    supplier.DefaultDueDateOption = (defaultDueDateOption as? Int) ?? 0
                    supplier.DefaultDueDate = (defaultDueDate as? Int) ?? 0
                    
                }
                
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
    
         DispatchQueue.main.async {
                self.ContactTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
                self.ContactSearchBox.resignFirstResponder()
                
            }


            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return "" as AnyObject
        }
        
        return "" as AnyObject
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        print("selected indexpath" + indexPath.row.description)
          _ = tableView.cellForRow(at: indexPath as IndexPath) as! SupplierSearchTableViewCell
        
     selectedSuplier = supplierData[indexPath.row]
        ContactSearchBox.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexpath" + indexPath.row.description)
        if indexPath.row == pageIndex*(pageSize - 5 )
        {
            let q6CommonLib = Q6CommonLib(myObject: self)
            pageIndex = pageIndex + 1
            
            setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
            dataRequestSource = ""
             q6CommonLib.Q6IosClientGetApi(ModelName: "Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
        
            pageIndex = 1
            supplierData.removeAll()
          selectedSuplier = nil
            
            dataRequestSource = "Search"
       
           setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
          q6CommonLib.Q6IosClientGetApi(ModelName: "Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
            
        }
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
     
        pageIndex = 1
        supplierData.removeAll()
       selectedSuplier = nil
        
        dataRequestSource = "Search"
        setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi(ModelName: "Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        
        searchBar.resignFirstResponder()
        
    }
    @IBAction func CancelButtonClick(sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        
           // navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func DoneButtonClick(sender: AnyObject) {
     
        if selectedSuplier == nil {
            
            Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "You haven't select a supplier", viewController: self)
        }
        else{
        
            self.delegate?.sendGoBackFromSupplierSearchView(fromView: "SupplierSearchViewController" ,forCell :fromCell,Contact: selectedSuplier!)
//        
            _ = navigationController?.popViewController(animated: true)
   
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
