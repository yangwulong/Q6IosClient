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
       var originalRowsDic: [Int: String] = [0: "InventoryCell", 1: "AccountCell",2: "DescriptionCell",3: "QuantityCell",4: "UnitPriceCell",5: "TaxCodeCell",6: "AmountCell"]
    
   
    var strDescription = String()
    var purchasesTransactionsDetailView = PurchasesTransactionsDetailView()
    
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

    PurchaseDetailDataLineTableView.delegate = self
        PurchaseDetailDataLineTableView.dataSource = self
        // Do any additional setup after loading the view.
        setControlAppear()
    }

    
    func setControlAppear()
    {
        // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        
     PurchaseDetailDataLineTableView.tableFooterView = UIView(frame: CGRectZero)
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
       
        if resuseIdentifier == "InventoryCell" {
            
            // print("purchasesTransactionsDetailView.AccountNameWithAccountNo" + purchasesTransactionsDetailView.AccountNameWithAccountNo)
           cell.lblInventoryName.text = purchasesTransactionsDetailView.InventoryNameWithInventoryNO
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "AccountCell" {
            
           // print("purchasesTransactionsDetailView.AccountNameWithAccountNo" + purchasesTransactionsDetailView.AccountNameWithAccountNo)
            cell.lblAccountNameWithNo.text = purchasesTransactionsDetailView.AccountNameWithAccountNo
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "DescriptionCell" {
            
          cell.lblDescription.text = purchasesTransactionsDetailView.Description
            
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "TaxCodeCell" {
            
     
            cell.lblTaxCodeName.text = purchasesTransactionsDetailView.TaxCodeName
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
      
        if resuseIdentifier == "AmountCell" {
            
            var amount = purchasesTransactionsDetailView.Amount
            var strAmount = String(amount)
            if amount != 0 {
                
                if strAmount.containsString(".") == true {
                    //Check decimal place whether less than 4
                    var strsplit = strAmount.characters.split(("."))
                    let strLast = String(strsplit.last!)
                    
                    if strLast.length > 2 {
//
                    
                        cell.lblAmount.text = String(Double(round(100 * amount)/100))
                    }
                    else {
                          cell.lblAmount.text = String(format: "%.2f", amount)
                        
                   
                    }
                    
                    
                }
                else {
                    cell.lblAmount.text = String(amount)
                }
                
                // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
                //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
            }
            else
            {
                cell.lblAmount.text = ""
            }
        }
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
        
        if originalRowsDic[indexPath.row] == "AccountCell" {
            
            performSegueWithIdentifier("showAccount", sender: "AccountCell")
            
            
        }
        
        
        if originalRowsDic[indexPath.row] == "TaxCodeCell" {
            
            performSegueWithIdentifier("showTaxCode", sender: "TaxCodeCell")
            
            
        }
        if originalRowsDic[indexPath.row] == "DescriptionCell" {
            
            performSegueWithIdentifier("showDescription", sender: "DescriptionCell")
            
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if sender is String {
            
            let fromCell = sender as! String
            //        if let fromCell = sender as? String {
            
            if fromCell == "InventoryCell"
            {
                var purchaseDetailDataLineInventorySearchViewController = segue.destinationViewController as! PurchaseDetailDataLineInventorySearchViewController
               purchaseDetailDataLineInventorySearchViewController.fromCell = "InventoryCell"
                
                purchaseDetailDataLineInventorySearchViewController.delegate = self
            }
           
            if fromCell == "AccountCell"
            {
                var purchaseDetailDataLineAccountSearchViewController = segue.destinationViewController as! PurchaseDetailDataLineAccountSearchViewController
                
                purchaseDetailDataLineAccountSearchViewController.fromCell = "AccountCell"
                
               purchaseDetailDataLineAccountSearchViewController.delegate = self
            }
            
            if fromCell == "TaxCodeCell"
            {
                var purchaseDetailDataLineTaxCodeSearchViewController = segue.destinationViewController as! PurchaseDetailDataLineTaxCodeSearchViewController
                
                purchaseDetailDataLineTaxCodeSearchViewController.fromCell = "TaxCodeCell"
                
                purchaseDetailDataLineTaxCodeSearchViewController.delegate = self
            }
            if fromCell == "DescriptionCell"
            {
                var purchaseDetailDataLineDescription = segue.destinationViewController as! PurchaseDetailDataLineDescriptionViewController
                
                purchaseDetailDataLineDescription.fromCell = "DescriptionCell"
                
                purchaseDetailDataLineDescription.delegate = self
                purchaseDetailDataLineDescription.textValue = purchasesTransactionsDetailView.Description
            }
        }
    }
    
    func  sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String){
        
    }
    
    func  sendGoBackFromContactSearchView(fromView : String ,forCell: String,Contact: Supplier){
        
    }
    
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate){
        
    }
    
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetail: PurchasesTransactionsDetail){
        
    }
    
     func sendGoBackFromPurchaseDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView){
        purchasesTransactionsDetailView.InventoryID = inventoryView.InventoryID
        purchasesTransactionsDetailView.InventoryNameWithInventoryNO = inventoryView.InventoryName
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
    func  sendGoBackFromPurchaseDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {
        purchasesTransactionsDetailView.Description = Description
        
        print("purchasesTransactionsDetailView.Description" + purchasesTransactionsDetailView.Description)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
    
     func  sendGoBackFromPurchaseDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
     {
        purchasesTransactionsDetailView.TaxCodeID = taxCodeView.TaxCodeID
        purchasesTransactionsDetailView.TaxCodeName = taxCodeView.TaxCodeName
        purchasesTransactionsDetailView.TaxRate = taxCodeView.TaxRate
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
 
    @IBAction func unitPriceEditingDidEnd(sender: AnyObject) {
        var UnitPriceTextField = sender as! UITextField
        var StrUnitPrice = UnitPriceTextField.text as String?
 
        if let UnitPrice = Double(StrUnitPrice!) {
            
            if UnitPrice >= 0 {
                
          
            if StrUnitPrice?.containsString(".") == true {
                //Check decimal place whether less than 4
                var strsplit = StrUnitPrice?.characters.split(("."))
                let strLast = String(strsplit?.last!)
                
                
                if strLast.length > 4 {
                    
                   
                    if UnitPrice == 0 {
                        UnitPriceTextField.text = "0.00"
                    } else {
                    //round to 4 decimal place
                    UnitPriceTextField.text = String(Double(round(10000 * UnitPrice)/10000))
                    }
                }
              
                
            }
               purchasesTransactionsDetailView.UnitPrice = UnitPrice
           
                
            }
            else {
                UnitPriceTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input negative decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
                purchasesTransactionsDetailView.UnitPrice = 0
            }
            
        }
        else {
            
            if StrUnitPrice?.length > 0 {
                 UnitPriceTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can only input decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
               
              
            }
              purchasesTransactionsDetailView.UnitPrice = 0
        }
        calculateAmount()
    }
    @IBAction func quantityEditingDidEnd(sender: AnyObject) {
        
        var QuantityTextField = sender as! UITextField
        var StrQuantity = QuantityTextField.text as String?
        
        if let Quantity = Double(StrQuantity!) {
            
            if Quantity != 0 {
                
                
                if StrQuantity?.containsString(".") == true {
                    //Check decimal place whether less than 4
                    var strsplit = StrQuantity?.characters.split(("."))
                    let strLast = String(strsplit?.last!)
                    
                    
                    if strLast.length > 4 {
                        
                        
                        if Quantity == 0 {
                            QuantityTextField.text = "0.00"
                        } else {
                            //round to 6 decimal place
                            QuantityTextField.text = String(Double(round(1000000 * Quantity)/1000000))
                        }
                    }
                    
                    
                }
                purchasesTransactionsDetailView.Quantity = Quantity
             
                
            }
            else {
                QuantityTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input zero here!", viewController: self)
                
                 QuantityTextField.text = ""
                purchasesTransactionsDetailView.Quantity = 0
            }
           
        }
        else {
            
            if StrQuantity?.length > 0 {
                QuantityTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can only input decimal number here!", viewController: self)
                
                QuantityTextField.text = ""
                
            }
             purchasesTransactionsDetailView.Quantity = 0
        }
        calculateAmount()
    }
    func calculateAmount()
    {
          purchasesTransactionsDetailView.Amount = purchasesTransactionsDetailView.UnitPrice * purchasesTransactionsDetailView.Quantity
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
       func  sendGoBackFromPurchaseDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
       {
        purchasesTransactionsDetailView.AccountID = accountView.AccountID
        purchasesTransactionsDetailView.AccountNameWithAccountNo = accountView.AccountNameWithAccountNo
        
      //   var taxCodeView = getTaxCodeByTaxCodeID()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
    
    
     func sendGoBackFromAddImageView(fromView: String, forCell: String, image:UIImage)
     {
        
    }
    @IBAction func CancelButtonClicked(sender: AnyObject) {
           navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
    }
//    func getTaxCodeByTaxCodeID() -> TaxCodeView {
//       
//        
//            let q6CommonLib = Q6CommonLib(myObject: self)
//        
//        
//        q6CommonLib.Q6IosClientGetApi("Company", ActionName: "GetTaxCodeList", attachedURL: attachedURL)
//        
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
