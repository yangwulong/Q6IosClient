//
//  SalesViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 8/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SalesViewController: UIViewController, Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{
    
//    @IBOutlet weak var SearchBar: UISearchBar!
  
    var pageIndex: Int = 1
    var pageSize: Int = 20
    var searchText: String = ""
    var dataRequestSource = ""
    var attachedURL = String()

    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var saleTableView: UITableView!
    //var attachedURL: String = "&Type=Allsales&SearchText=&PageSize=200&PageIndex=1"
    
    @IBOutlet weak var SaleSearchBox: UISearchBar!
    
    var saleTransactionListData = [SalesTransactionsListView]()
    
    var selectedRowNo : Int = 0
    override func viewWillAppear(animated: Bool) {
        //  self.navigationController?.navigationBar.hidden = true
        //    Q6ActivityIndicatorView.center = saleTableView.center
        
        
        
    }
    override func viewDidAppear(animated: Bool) {
        Q6ActivityIndicatorView.startAnimating()
        setControlAppear()
        let q6CommonLib = Q6CommonLib(myObject: self)
        // var attachedURL: String = "&Type=AllPurchases&SearchText=&StartDate=&EndDate=&PageSize=20&PageIndex=" + String(pageIndex)
        
        setAttachedURL(searchText, PageSize: pageSize, PageIndex: pageIndex)
        dataRequestSource = "Search"
        q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
        
        saleTableView.delegate = self
        saleTableView.dataSource = self
        SaleSearchBox.delegate = self
        
        //        purchaseTableView.registerClass(cellClass:PurchaseTableViewCell.self, forCellWithReuseIdentifier: "PurchasePototypeCELL")
    }
    func setControlAppear()
    {
        
        SaleSearchBox.layer.cornerRadius = 2;
        SaleSearchBox.layer.borderWidth = 0.1;
        SaleSearchBox.layer.borderColor = UIColor.blackColor().CGColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                saleTransactionListData.removeAll()
            }
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["SalesTransactionsHeaderList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            for i in 0  ..< returnData.count {
                
                
                print("no i =" + i.description)
                var dataItem = returnData[i]
                var salesTransactionListViewDataItem =  SalesTransactionsListView()
                
                salesTransactionListViewDataItem.SalesTransactionsHeaderID = dataItem["SalesTransactionsHeaderID"] as! String
                salesTransactionListViewDataItem.Overdueby = dataItem["Overdueby"] as? String
                
                salesTransactionListViewDataItem.CustomerID = dataItem["CustomerID"] as! String
                
                salesTransactionListViewDataItem.CustomerName = dataItem["CustomerName"] as! String
                
                salesTransactionListViewDataItem.ReferenceNo = dataItem["ReferenceNo"] as! String
                
                
                salesTransactionListViewDataItem.SalesType = dataItem["SalesType"] as! String
                salesTransactionListViewDataItem.SalesStatus = dataItem["SalesStatus"] as! String
                
                salesTransactionListViewDataItem.SalesStatusString = dataItem["SalesStatusString"] as! String
                
                var memo = dataItem["Memo"] as? String
                
                if memo != nil {
                    
                    salesTransactionListViewDataItem.Memo = dataItem["Memo"] as! String
                    
                }
                else{
                    salesTransactionListViewDataItem.Memo = ""
                }
                
                
                var DueDate = dataItem["DueDate"] as? String
                //                var convertDueDate = NSDate?()
                //                if dueDate != nil {
                //                print("dueDate sss" + dueDate!)
                //
                //                    convertDueDate = dueDate?.toDateTime()
                //
                //                }
                salesTransactionListViewDataItem.DueDate = DueDate?.toDateTime()
                
                var TransactionDate = dataItem["TransactionDate"] as! String
                
                salesTransactionListViewDataItem.TransactionDate = TransactionDate.toDateTime()!
                salesTransactionListViewDataItem.TotalAmount = dataItem["TotalAmount"] as! Double
                //                  purchasesTransactionListViewDataItem.DebitAmount = dataItem["DebitAmount"] as! Double
                salesTransactionListViewDataItem.HasLinkedDoc = dataItem["HasLinkedDoc"] as! Bool
                // purchasesTransactionListViewDataItem.TransactionDate = dataItem["TransactionDate"] as! NSDate
                
                var ClosedDate = dataItem["ClosedDate"] as? String
                salesTransactionListViewDataItem.ClosedDate = ClosedDate?.toDateTime()
                //print("Transaction Date" + dataItem["TransactionDate"])
                saleTransactionListData.append(salesTransactionListViewDataItem)
                
//                printFields(saleTransactionListViewDataItem)
            }
//            print("Sale TransactionListdata count" + purchaseTransactionListData.count.description)
            //  self.purchaseTableView.reloadData()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.saleTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
                self.SaleSearchBox.resignFirstResponder()
                
            })
            
            //        var dd = try  NSJSONSerialization.JSONObjectWithData(postDicData["salesTransactionsHeaderList"]! as! NSData, options: []) as! [AnyObject]
            //let dataDict = try  NSJSONSerialization.JSONObjectWithData(postDicData["PurchasesTransactionsHeaderList"]! as! NSData, options: NSJSONReadingOptions.MutableContainers) as! [[String:String]]
            
            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }
        
        return ""
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        print("indexpath" + indexPath.row.description)
        if indexPath.row == pageIndex*(pageSize - 5 )
        {
            let q6CommonLib = Q6CommonLib(myObject: self)
            pageIndex++
            setAttachedURL(searchText, PageSize: pageSize, PageIndex: pageIndex)
            dataRequestSource = ""
            q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
        }
        
    }
    
    func setAttachedURL(SearchText: String , PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Type=AllSales&SearchText=" + SearchText + "&StartDate=&EndDate=&PageSize=" + String(pageSize) + "&PageIndex=" + String(pageIndex)
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            pageIndex = 1
            saleTransactionListData.removeAll()
            
            dataRequestSource = "Search"
            print("saleTransactionListdata count" + saleTransactionListData.count.description)
            setAttachedURL(searchText, PageSize: pageSize, PageIndex: pageIndex)
            q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
            
        }
    }
//    func printFields(salesTransactionListViewDataItem : salesTransactionsListView)
//    {
//        print("SalesTransactionsHeaderID" + salesTransactionListViewDataItem.SalesTransactionsHeaderID)
//        
//        if let Overdueby = salesTransactionListViewDataItem.Overdueby {
//            print("Overdueby " + Overdueby)
//        } else {
//            print("Overdueby nil")
//        }
//        
//        print("SupplierID " + salesTransactionListViewDataItem.SupplierID)
//        
//        print("SupplierName " + salesTransactionListViewDataItem.SupplierName)
//        print("ReferenceNO" + salesTransactionListViewDataItem.ReferenceNo)
//        print("PurchasesType " + salesTransactionListViewDataItem.PurchasesType)
//        print("PurchasesStatus"  + salesTransactionListViewDataItem.PurchasesStatus)
//        print("PurchasesStatusString" + salesTransactionListViewDataItem.PurchasesStatusString)
//        print("Memo"  + salesTransactionListViewDataItem.Memo)
//        
//        
//        
//        
//        if let dueDates = salesTransactionListViewDataItem.DueDate  {
//            
//            print("DueDate " + dueDates.formatted)
//        }
//        else {
//            print("DueDate nil")
//        }
//        
//        print("TransactionDate"  + salesTransactionListViewDataItem.TransactionDate.formatted)
//        print("TotalAmount" + salesTransactionListViewDataItem.TotalAmount.description)
//        //                     print("DebitAmount" + purchasesTransactionListViewDataItem.DebitAmount.description)
//        //                print("TransactionDate " + (purchasesTransactionListViewDataItem.TransactionDate).formatted)
//        print("HasLinkedDoc" + salesTransactionListViewDataItem.HasLinkedDoc.description)
//        
//        if let closedDates = salesTransactionListViewDataItem.ClosedDate  {
//            
//            print("ClosedDate " + closedDates.formatted)
//        }
//        else {
//            print("ClosedDate nil")
//        }
//    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleTransactionListData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCellWithIdentifier("SalePototypeCELL", forIndexPath: indexPath) as! SaleTableViewCell
        
        
        cell.lblMemo.text = saleTransactionListData[indexPath.row].Memo
        
        let TotalAmount = saleTransactionListData[indexPath.row].TotalAmount
        cell.lblTotalAmount.text = String(format: "%.2f", TotalAmount)
        cell.lblCustomerName.text =  saleTransactionListData[indexPath.row].CustomerName
        cell.lblCustomerName.font =  UIFont.boldSystemFontOfSize(18.0)
        
        let TransactionDate = saleTransactionListData[indexPath.row].TransactionDate
        cell.lblTransactionDate.text = TransactionDate.formatted
        
        // Configure the cell...
        
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedRowNo = indexPath.row
        
        self.performSegueWithIdentifier("editSaleDetail", sender: "SalePototypeCELL")
        SaleSearchBox.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar!)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        pageIndex = 1
        saleTransactionListData.removeAll()
        
        dataRequestSource = "Search"
        print("saleTransactionListdata count" + saleTransactionListData.count.description)
        setAttachedURL(searchText, PageSize: 20, PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
        
        searchBar.resignFirstResponder()
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "createSaleDetail" {
            
            var operationType = OperationType()
            
            var saleDetailViewController = segue.destinationViewController as! SaleDetailViewController
            saleDetailViewController.operationType = operationType.Create
            print("saleDetailViewController.operationType" + saleDetailViewController.operationType)
            //            purchaseDetailDataLineInventorySearchViewController.delegate = self
            
        }
        if segue.identifier == "editSaleDetail" {
            
            var operationType = OperationType()
            
            var saleDetailViewController = segue.destinationViewController as! SaleDetailViewController
            saleDetailViewController.operationType = operationType.Edit
            saleDetailViewController.salesTransactionHeader.SalesTransactionsHeaderID = saleTransactionListData[selectedRowNo].SalesTransactionsHeaderID
            
            print("saleDetailViewController.operationType" + saleDetailViewController.operationType)
            //            purchaseDetailDataLineInventorySearchViewController.delegate = self
            
        }
        
        
    }
}
