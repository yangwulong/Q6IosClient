//
//  PurchaseDetailDataLineTaxCodeSearchViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 17/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailDataLineTaxCodeSearchViewController:UIViewController, Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{

    @IBOutlet weak var Q6ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var TaxCodeTableView: UITableView!
    @IBOutlet weak var taxCodeSearchBox: UISearchBar!
    var dataRequestSource = ""
    var taxCodeViewData = [TaxCodeView]()
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
      var attachedURL = String()
      var searchText: String = ""
    
    var pageIndex: Int = 1
    var pageSize: Int = 1000
    
    var selectedTaxCodeView = TaxCodeView?()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        TaxCodeTableView.delegate = self
        TaxCodeTableView.dataSource = self
        taxCodeSearchBox.delegate = self
        Q6ActivityIndicator.startAnimating()
        // Do any additional setup after loading the view.
        setControlAppear()
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        setAttachedURL(searchText, TaxCodeType:"PayTax",IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi("Company", ActionName: "GetTaxCodeList", attachedURL: attachedURL)
        
    }

    func setControlAppear()
    {
        
        taxCodeSearchBox.layer.cornerRadius = 2;
        taxCodeSearchBox.layer.borderWidth = 0.1;
        taxCodeSearchBox.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    //TaxCodeType All ,CollectTax ,PayTax
    func setAttachedURL(SearchText: String , TaxCodeType: String ,IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Search=" + SearchText + "&TaxCodeType=" + TaxCodeType + "&IsLoadInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(PageIndex)
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
        return taxCodeViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCellWithIdentifier("TaxCodeCell", forIndexPath: indexPath) as! PurchaseDetailDataLineTaxCodeSearchTableViewCell
        
        cell.lblTaxCodeName.text = taxCodeViewData[indexPath.row].TaxCodeName
        
        var taxRate = taxCodeViewData[indexPath.row].TaxRate
        let taxRateWithTwoDecimalPlaces = String(format: "%.2f", taxRate)
        cell.lblTaxRate.text = String(taxRateWithTwoDecimalPlaces) + "%"
//        cell.lblSupplierID.hidden = true
//        
//        
//        cell.lblSupplierName.text =  supplierData[indexPath.row].SupplierName
//        
//        cell.lblSupplierID.text =  supplierData[indexPath.row].SupplierID
        
        // Configure the cell...
        
        return cell
    }
    
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                taxCodeViewData.removeAll()
              selectedTaxCodeView = nil 
            }
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["TaxCodeList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
//            
            for i in 0  ..< returnData.count {
                
                //
                //                print("no i =" + i.description)
                var dataItem = returnData[i]
                
                var taxCodeView = TaxCodeView()
                taxCodeView.TaxCodeID = dataItem["TaxCodeID"] as! String
                
         
                taxCodeView.TaxCodeName = dataItem["TaxCodeName"] as! String
       
                taxCodeView.TaxRate = dataItem["TaxRate"] as! Double
                
               taxCodeViewData.append(taxCodeView)
                //
                //                printFields(purchasesTransactionListViewDataItem)
            }
//
//            print("supplier Date Count" + supplierData.count.description)
//            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.TaxCodeTableView.reloadData()
                self.Q6ActivityIndicator.hidesWhenStopped = true
                self.Q6ActivityIndicator.stopAnimating()
                self.taxCodeSearchBox.resignFirstResponder()
                
            })
//
//            
//            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }
        
        return ""
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
selectedTaxCodeView = taxCodeViewData[indexPath.row]
        taxCodeSearchBox.resignFirstResponder()
    }
    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
           navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        self.delegate?.sendGoBackFromPurchaseDetailDataLineTaxCodeSearchView("PurchaseDetailDataLineTaxCodeSearchViewController", forCell: "TaxCodeCell", taxCodeView: selectedTaxCodeView!)
        navigationController?.popViewControllerAnimated(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
//        if searchText.length == 0 {
//            
//            
//            
//            let q6CommonLib = Q6CommonLib(myObject: self)
//            
//         
//            taxCodeViewData.removeAll()
// selectedTaxCodeView = nil
//            
//            dataRequestSource = "Search"
//            
//            setAttachedURL(searchText, TaxCodeType:"PayTax",IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
//            q6CommonLib.Q6IosClientGetApi("Company", ActionName: "GetTaxCodeList", attachedURL: attachedURL)
//            
//        }
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
       
        
      
        taxCodeViewData.removeAll()
     selectedTaxCodeView = nil
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        setAttachedURL(searchText, TaxCodeType:"PayTax",IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi("Company", ActionName: "GetTaxCodeList", attachedURL: attachedURL)
        taxCodeSearchBox.resignFirstResponder()
        
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
