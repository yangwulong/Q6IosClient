//
//  PurchaseDetailDataLineViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 11/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailDataLineViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView {

    @IBOutlet weak var PurchaseDetailDataLineTableView: UITableView!
       var originalRowsDic: [Int: String] = [0: "InventoryCell", 1: "AccountCell",2: "QuantityCell",3: "UnitPriceCell",4: "TaxCell",5: "AmountCell",6: "DescriptionCell"]
    override func viewDidLoad() {
        super.viewDidLoad()

    PurchaseDetailDataLineTableView.delegate = self
        PurchaseDetailDataLineTableView.dataSource = self
        // Do any additional setup after loading the view.
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
        // #warning Incomplete implementation, return the number of rows
        
        // print("addItemsDic" + addItemsDic.count.description)
        // return originalRowsDic.count + addItemsDic.count
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     var resuseIdentifier = String()
//        if indexPath.row <= 8 {
           resuseIdentifier = originalRowsDic[indexPath.row]!
//        }
//        if indexPath.row > 8 {
//            resuseIdentifier = originalRowsDic[5]!
//        }
//        
//        var screenSortLinesDetail = purchasesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
//        
     // resuseIdentifier = screenSortLinesDetail.PrototypeCellID
       let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! PurchaseDetailDataLineTableViewCell
//        
    
//        
//        if resuseIdentifier == "PurchasesTypecell" {
//            
//            cell.lblPurchasesType.text = purchasesTransactionHeader.PurchasesType
//            
//            
//            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
//            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
//        }
//        if resuseIdentifier == "SupplierCell" {
//            
//            cell.lblSupplierName.text = SupplierName
//            
//            
//            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
//            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
//        }
//        
//        if resuseIdentifier == "DueDateCell" {
//            
//            if purchasesTransactionHeader.DueDate == nil {
//                
//                
//                purchasesTransactionHeader.DueDate = NSDate()
//            }
//            
//            //
//            cell.lblDueDate.text = purchasesTransactionHeader.DueDate!.formatted
//            
//            
//            
//        }
//        
//        if resuseIdentifier == "AddanItemCell" {
//            
//            if purchasesDetailScreenLinesDic[indexPath.row].isAdded == true {
//                
//                let image = UIImage(named: "Minus-25") as UIImage?
//                
//                
//                
//                // let image = UIImage(named: "name") as UIImage?
//                // cell.AddDeleteButton = UIButton(type: .System) as UIButton
//                
//                
//                cell.AddDeleteButton.setImage(image, forState: .Normal)
//                cell.LineDescription.text = "Added dataLine"
//                //   cell.AddDeleteButton.frame = CGRectMake(0, 0, 15, 15)
//                //  cell.AddDeleteButton = UIButton(type: UIButtonType.Custom)
//            }
//            
//        }
//        
//        
//        if resuseIdentifier == "TotalCell" {
//            
//            cell.lblTotalAmountLabel.font = UIFont.boldSystemFontOfSize(17.0)
//            cell.lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
//            
//            
//            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
//            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
//        }
        return cell
        
        
        // Configure the cell...
        print("indexPath" + indexPath.row.description)
        
        //return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row //2
        
      
        if originalRowsDic[indexPath.row] == "InventoryCell" {
            
            performSegueWithIdentifier("showPurchaseDetailDataLineViewController", sender: "InventoryCell")
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if sender is String {
            
            let fromCell = sender as! String
            //        if let fromCell = sender as? String {
            
            if fromCell == "InventoryCell"
            {
                var preLoadInventoryPurchaseViewController = segue.destinationViewController as! PreLoadInventoryPurchaseViewController
               preLoadInventoryPurchaseViewController.fromCell = "InventoryCell"
                
                preLoadInventoryPurchaseViewController.delegate = self
            }
        }
    }
    
    func  sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String){
        
    }
    
    func  sendGoBackFromContactSearchView(fromView : String ,forCell: String,ContactID : String ,ContactName:String){
        
    }
    
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate){
        
    }
    
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetail: PurchasesTransactionsDetail){
        
    }
    
    func sendGoBackFromPreLoadInventoryPurchaseView(fromView:String,forCell:String,preLoadInventoryPurchase: PreLoadInventoryPurchase){
        
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
