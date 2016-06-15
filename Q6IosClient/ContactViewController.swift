//
//  ContactViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 15/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol {
  var originalRowsDic: [Int: String] = [0: "ContactNameCell", 1: "PhoneCell",2: "EmailCell",3: "MemoCell"]
    
    @IBOutlet weak var ContactTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        ContactTableView.delegate = self
        ContactTableView.dataSource = self
        setControlAppear()
        // Do any additional setup after loading the view.
    }

    func setControlAppear()
    {
        // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        
        ContactTableView.tableFooterView = UIView(frame: CGRectZero)
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
        return 4
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var resuseIdentifier = String()
        
        resuseIdentifier = originalRowsDic[indexPath.row]!
        //        if indexPath.row <= 8 {
        //       resuseIdentifier = originalRowsDic[indexPath.row]!
        //        }
        //        if indexPath.row > 8 {
        //             resuseIdentifier = originalRowsDic[5]!
        //        }
        
   let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! ContactViewTableViewCell
        if resuseIdentifier == "MemoCell" {
            
        
        
     
        
          //  cell.lblContactName.text = "Supplier Name"
        }
//        if resuseIdentifier == "PurchasesTypecell" {
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 3{
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenHeight = screenSize.height
           return screenHeight - 3*40
        }
        else {
            return 40
        }
    }
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        return ""
    }
    
    func  sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String)
    {}
    func  sendGoBackFromSupplierSearchView(fromView : String ,forCell: String,Contact: Supplier)
    {}
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
    {}
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetailView: PurchasesTransactionsDetailView)
    {}
    func sendGoBackFromPurchaseDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView)
    {}
    func  sendGoBackFromPurchaseDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {}
    func  sendGoBackFromPurchaseDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    {}
    func  sendGoBackFromPurchaseDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    {}
    func sendGoBackFromAddImageView(fromView: String, forCell: String, image:UIImage)
    {}
    func  sendGoBackFromPurchaseDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {}
    
    func sendGoBackFromSaleDetailDataLineView(fromView:String,forCell:String,salesTransactionsDetailView: SalesTransactionsDetailView)
    {}
    func sendGoBackFromSaleDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView)
    {}
    func  sendGoBackFromSaleDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {}
    func  sendGoBackFromSaleDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    {}
    
    func  sendGoBackFromSaleDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    {}
    
    
    func  sendGoBackFromSaleDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {}
    func  sendGoBackFromCustomerSearchView(fromView : String ,forCell: String,Contact: Customer)
    {}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
