//
//  SalesViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 8/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SalesViewController: UIViewController, Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate,Q6GoBackFromViewTwo{
    
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
    override func viewWillAppear(_ animated: Bool) {
        //  self.navigationController?.navigationBar.hidden = true
        //    Q6ActivityIndicatorView.center = saleTableView.center
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
        
        saleTableView.delegate = self
        saleTableView.dataSource = self
        SaleSearchBox.delegate = self
        
        
        Q6ActivityIndicatorView.startAnimating()
        setControlAppear()
        let q6CommonLib = Q6CommonLib(myObject: self)
        // var attachedURL: String = "&Type=AllPurchases&SearchText=&StartDate=&EndDate=&PageSize=20&PageIndex=" + String(pageIndex)
        
        setAttachedURL(SearchText: searchText, PageSize: pageSize, PageIndex: pageIndex)
        dataRequestSource = "Search"
        q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
        
        
        //        purchaseTableView.registerClass(cellClass:PurchaseTableViewCell.self, forCellWithReuseIdentifier: "PurchasePototypeCELL")
    }
    func setControlAppear()
    {
        
        SaleSearchBox.layer.cornerRadius = 2;
        SaleSearchBox.layer.borderWidth = 0.1;
        SaleSearchBox.layer.borderColor = UIColor.black.cgColor
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
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                saleTransactionListData.removeAll()
            }
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["SalesTransactionsHeaderList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            for i in 0  ..< returnData.count {
                
                
                print("no i =" + i.description)
                var dataItem = returnData[i]
                let salesTransactionListViewDataItem =  SalesTransactionsListView()
                
                salesTransactionListViewDataItem.SalesTransactionsHeaderID = dataItem["SalesTransactionsHeaderID"] as! String
                salesTransactionListViewDataItem.Overdueby = dataItem["Overdueby"] as? String
                
                salesTransactionListViewDataItem.CustomerID = dataItem["CustomerID"] as! String
                
                salesTransactionListViewDataItem.CustomerName = dataItem["CustomerName"] as! String
                
                salesTransactionListViewDataItem.ReferenceNo = dataItem["ReferenceNo"] as! String
                
                
                salesTransactionListViewDataItem.SalesType = dataItem["SalesType"] as! String
                salesTransactionListViewDataItem.SalesStatus = dataItem["SalesStatus"] as! String
                
                salesTransactionListViewDataItem.SalesStatusString = dataItem["SalesStatusString"] as! String
                
                let memo = dataItem["Memo"] as? String
                
                if memo != nil {
                    
                    salesTransactionListViewDataItem.Memo = dataItem["Memo"] as! String
                    
                }
                else{
                    salesTransactionListViewDataItem.Memo = ""
                }
                
                
                let DueDate = dataItem["DueDate"] as? String
                //                var convertDueDate:NSDate?
                //                if dueDate != nil {
                //                print("dueDate sss" + dueDate!)
                //
                //                    convertDueDate = dueDate?.toDateTime()
                //
                //                }
                salesTransactionListViewDataItem.DueDate = DueDate?.toDateTime()
                
                let TransactionDate = dataItem["TransactionDate"] as! String
                
                salesTransactionListViewDataItem.TransactionDate = TransactionDate.toDateTime()!
                salesTransactionListViewDataItem.TotalAmount = dataItem["TotalAmount"] as! Double
                //                  purchasesTransactionListViewDataItem.DebitAmount = dataItem["DebitAmount"] as! Double
                salesTransactionListViewDataItem.HasLinkedDoc = dataItem["HasLinkedDoc"] as! Bool
                // purchasesTransactionListViewDataItem.TransactionDate = dataItem["TransactionDate"] as! NSDate
                
                let ClosedDate = dataItem["ClosedDate"] as? String
                salesTransactionListViewDataItem.ClosedDate = ClosedDate?.toDateTime()
                //print("Transaction Date" + dataItem["TransactionDate"])
                saleTransactionListData.append(salesTransactionListViewDataItem)
                
//                printFields(saleTransactionListViewDataItem)
            }
//            print("Sale TransactionListdata count" + purchaseTransactionListData.count.description)
            //  self.purchaseTableView.reloadData()
            DispatchQueue.main.async {
                self.saleTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
                self.SaleSearchBox.resignFirstResponder()
                
            }
            
            //        var dd = try  NSJSONSerialization.JSONObjectWithData(postDicData["salesTransactionsHeaderList"]! as! NSData, options: []) as! [AnyObject]
            //let dataDict = try  NSJSONSerialization.JSONObjectWithData(postDicData["PurchasesTransactionsHeaderList"]! as! NSData, options: NSJSONReadingOptions.MutableContainers) as! [[String:String]]
            
            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return "" as AnyObject
        }
        
        return "" as AnyObject
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexpath" + indexPath.row.description)
        if indexPath.row == pageIndex*(pageSize - 5 )
        {
            let q6CommonLib = Q6CommonLib(myObject: self)
            pageIndex = pageIndex + 1
            setAttachedURL(SearchText: searchText, PageSize: pageSize, PageIndex: pageIndex)
            dataRequestSource = ""
            q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
        }
        
    }
    
    func setAttachedURL(SearchText: String , PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Type=AllSales&SearchText=" + SearchText + "&StartDate=&EndDate=&PageSize=" + String(pageSize) + "&PageIndex=" + String(pageIndex)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            pageIndex = 1
            saleTransactionListData.removeAll()
            
            dataRequestSource = "Search"
            print("saleTransactionListdata count" + saleTransactionListData.count.description)
            setAttachedURL(SearchText: searchText, PageSize: pageSize, PageIndex: pageIndex)
            q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
            
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
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saleTransactionListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "SalePototypeCELL", for: indexPath) as! SaleTableViewCell
        
        
        cell.lblMemo.text = saleTransactionListData[indexPath.row].Memo
        
        let TotalAmount = saleTransactionListData[indexPath.row].TotalAmount
        cell.lblTotalAmount.text = String(format: "%.2f", TotalAmount)
        cell.lblCustomerName.text =  saleTransactionListData[indexPath.row].CustomerName
        cell.lblCustomerName.font =  UIFont.boldSystemFont(ofSize: 18.0)
        
        let TransactionDate = saleTransactionListData[indexPath.row].TransactionDate
        cell.lblTransactionDate.text = TransactionDate.formatted
        
        // Configure the cell...
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRowNo = indexPath.row
        
        self.performSegue(withIdentifier: "editSaleDetail", sender: "SalePototypeCELL")
        SaleSearchBox.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        pageIndex = 1
        saleTransactionListData.removeAll()
        
        dataRequestSource = "Search"
        print("saleTransactionListdata count" + saleTransactionListData.count.description)
        setAttachedURL(SearchText: searchText, PageSize: 20, PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
        
        searchBar.resignFirstResponder()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "createSaleDetail" {
            
            let operationType = OperationType()
            
            let saleDetailViewController = segue.destination as! SaleDetailViewController
            saleDetailViewController.operationType = operationType.Create
            print("saleDetailViewController.operationType" + saleDetailViewController.operationType)
            //            purchaseDetailDataLineInventorySearchViewController.delegate = self
            saleDetailViewController.delegate2 = self
            
        }
        if segue.identifier == "editSaleDetail" {
            
            let operationType = OperationType()
            
            let saleDetailViewController = segue.destination as! SaleDetailViewController
            saleDetailViewController.operationType = operationType.Edit
            saleDetailViewController.salesTransactionHeader.SalesTransactionsHeaderID = saleTransactionListData[selectedRowNo].SalesTransactionsHeaderID
              saleDetailViewController.delegate2 = self
            print("saleDetailViewController.operationType" + saleDetailViewController.operationType)
            //            purchaseDetailDataLineInventorySearchViewController.delegate = self
            
        }
        
        
    }
    
    func  sendGoBackFromPurchaseDetailView(fromView : String ,fromButton: String)
    {
        
//        Q6ActivityIndicatorView.startAnimating()
//        setControlAppear()
//        let q6CommonLib = Q6CommonLib(myObject: self)
//        // var attachedURL: String = "&Type=AllPurchases&SearchText=&StartDate=&EndDate=&PageSize=20&PageIndex=" + String(pageIndex)
//        pageIndex = 1
//        purchaseTransactionListData.removeAll()
//        setAttachedURL(searchText, PageSize: pageSize, PageIndex: pageIndex)
//        dataRequestSource = "Search"
//        
//        q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsList", attachedURL: attachedURL)
    }
    
    func  sendGoBackSaleDetailView(fromView : String ,fromButton: String){
        
        Q6ActivityIndicatorView.startAnimating()
        setControlAppear()
        let q6CommonLib = Q6CommonLib(myObject: self)
        // var attachedURL: String = "&Type=AllPurchases&SearchText=&StartDate=&EndDate=&PageSize=20&PageIndex=" + String(pageIndex)
        pageIndex = 1
        saleTransactionListData.removeAll()
        setAttachedURL(SearchText: searchText, PageSize: pageSize, PageIndex: pageIndex)
        dataRequestSource = "Search"
        q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetSaleTransactionsList", attachedURL: attachedURL)
    }
    func  sendGoBackContactDetailView(fromView : String ,fromButton: String)
    {
    
    }
}
