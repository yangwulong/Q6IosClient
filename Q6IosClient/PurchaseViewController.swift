//
//  PurchaseViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController, Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var purchaseTableView: PurchaseTableView!
    //var attachedURL: String = "&Type=AllPurchases&SearchText=&PageSize=200&PageIndex=1"
        var attachedURL: String = "&Type=AllPurchases&SearchText=&StartDate=2016-03-15&EndDate=2016-04-14&PageSize=200&PageIndex=1"
    @IBOutlet weak var PurchaseSearchBox: UISearchBar!
    
    var purchaseTransactionListData = [PurchasesTransactionsListView]()
    override func viewDidLoad() {
        super.viewDidLoad()

        setControlAppear()
  let q6CommonLib = Q6CommonLib(myObject: self)
      
        q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsList", attachedURL: attachedURL)
        

     
        // Do any additional setup after loading the view.
        
        purchaseTableView.delegate = self
        purchaseTableView.dataSource = self
     
//        purchaseTableView.registerClass(cellClass:PurchaseTableViewCell.self, forCellWithReuseIdentifier: "PurchasePototypeCELL")
    }
    func setControlAppear()
    {
        
        PurchaseSearchBox.layer.cornerRadius = 2;
        PurchaseSearchBox.layer.borderWidth = 0.1;
        PurchaseSearchBox.layer.borderColor = UIColor.blackColor().CGColor
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
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
           var returnData = postDicData["PurchasesTransactionsHeaderList"] as! [[String : AnyObject]]
            
            for i in 0  ..< returnData.count {
                var dataItem = returnData[i]
                var purchasesTransactionListViewDataItem =  PurchasesTransactionsListView()
                
                purchasesTransactionListViewDataItem.PurchasesTransactionsHeaderID = dataItem["PurchasesTransactionsHeaderID"] as! String
                purchasesTransactionListViewDataItem.Overdueby = dataItem["Overdueby"] as? String
                
                purchasesTransactionListViewDataItem.SupplierID = dataItem["SupplierID"] as! String
                
                purchasesTransactionListViewDataItem.SupplierName = dataItem["SupplierName"] as! String
                
                purchasesTransactionListViewDataItem.ReferenceNo = dataItem["ReferenceNo"] as! String
                
           
                purchasesTransactionListViewDataItem.PurchasesType = dataItem["PurchasesType"] as! String
                purchasesTransactionListViewDataItem.PurchasesStatus = dataItem["PurchasesStatus"] as! String
                
                purchasesTransactionListViewDataItem.PurchasesStatusString = dataItem["PurchasesStatusString"] as! String
                purchasesTransactionListViewDataItem.Memo = dataItem["Memo"] as! String
                
                
               
                
              var DueDate = dataItem["DueDate"] as? String
//                var convertDueDate = NSDate?()
//                if dueDate != nil {
//                print("dueDate sss" + dueDate!)
//                    
//                    convertDueDate = dueDate?.toDateTime()
//                
//                }
                purchasesTransactionListViewDataItem.DueDate = DueDate?.toDateTime()
                
                var TransactionDate = dataItem["TransactionDate"] as! String
                
                purchasesTransactionListViewDataItem.TransactionDate = TransactionDate.toDateTime()!
                purchasesTransactionListViewDataItem.TotalAmount = dataItem["TotalAmount"] as! Double
//                  purchasesTransactionListViewDataItem.DebitAmount = dataItem["DebitAmount"] as! Double
               purchasesTransactionListViewDataItem.HasLinkedDoc = dataItem["HasLinkedDoc"] as! Bool
               // purchasesTransactionListViewDataItem.TransactionDate = dataItem["TransactionDate"] as! NSDate
                
                var ClosedDate = dataItem["ClosedDate"] as? String
                purchasesTransactionListViewDataItem.ClosedDate = ClosedDate?.toDateTime()
                //print("Transaction Date" + dataItem["TransactionDate"])
                purchaseTransactionListData.append(purchasesTransactionListViewDataItem)
            
                printFields(purchasesTransactionListViewDataItem)
            }
            
          //  self.purchaseTableView.reloadData()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.purchaseTableView.reloadData()
            })
       
//        var dd = try  NSJSONSerialization.JSONObjectWithData(postDicData["PurchasesTransactionsHeaderList"]! as! NSData, options: []) as! [AnyObject]
            //let dataDict = try  NSJSONSerialization.JSONObjectWithData(postDicData["PurchasesTransactionsHeaderList"]! as! NSData, options: NSJSONReadingOptions.MutableContainers) as! [[String:String]]

            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }

        return ""
    }
    
    func printFields(purchasesTransactionListViewDataItem : PurchasesTransactionsListView)
    {
        print("PurchasesTransactionsHeaderID" + purchasesTransactionListViewDataItem.PurchasesTransactionsHeaderID)
        
        if let Overdueby = purchasesTransactionListViewDataItem.Overdueby {
            print("Overdueby " + Overdueby)
        } else {
            print("Overdueby nil")
        }
        
        print("SupplierID " + purchasesTransactionListViewDataItem.SupplierID)
        
        print("SupplierName " + purchasesTransactionListViewDataItem.SupplierName)
        print("ReferenceNO" + purchasesTransactionListViewDataItem.ReferenceNo)
        print("PurchasesType " + purchasesTransactionListViewDataItem.PurchasesType)
        print("PurchasesStatus"  + purchasesTransactionListViewDataItem.PurchasesStatus)
        print("PurchasesStatusString" + purchasesTransactionListViewDataItem.PurchasesStatusString)
        print("Memo"  + purchasesTransactionListViewDataItem.Memo)
        
        
      
        
        if let dueDates = purchasesTransactionListViewDataItem.DueDate  {
            
            print("DueDate " + dueDates.formatted)
        }
        else {
            print("DueDate nil")
        }
     
        print("TransactionDate"  + purchasesTransactionListViewDataItem.TransactionDate.formatted)
        print("TotalAmount" + purchasesTransactionListViewDataItem.TotalAmount.description)
        //                     print("DebitAmount" + purchasesTransactionListViewDataItem.DebitAmount.description)
        //                print("TransactionDate " + (purchasesTransactionListViewDataItem.TransactionDate).formatted)
        print("HasLinkedDoc" + purchasesTransactionListViewDataItem.HasLinkedDoc.description)
        
        if let closedDates = purchasesTransactionListViewDataItem.ClosedDate  {
            
            print("ClosedDate " + closedDates.formatted)
        }
        else {
            print("ClosedDate nil")
        }
    }
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
    
         func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return purchaseTransactionListData.count
        }
    
         func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let  cell = tableView.dequeueReusableCellWithIdentifier("PurchasePototypeCELL", forIndexPath: indexPath) as! PurchaseTableViewCell
            
           
            cell.lblMemo.text = purchaseTransactionListData[indexPath.row].Memo
           
             let TotalAmount = purchaseTransactionListData[indexPath.row].TotalAmount
            cell.lblTotalAmount.text = TotalAmount.description
            cell.lblSupplierName.text =  purchaseTransactionListData[indexPath.row].SupplierName
            
            let TransactionDate = purchaseTransactionListData[indexPath.row].TransactionDate
            cell.lblTransactionDate.text = TransactionDate.formatted
            
            // Configure the cell...
            
            return cell
        }
   
   
}
