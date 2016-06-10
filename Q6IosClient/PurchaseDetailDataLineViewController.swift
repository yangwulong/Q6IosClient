//
//  PurchaseDetailDataLineViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 11/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//


// default is taxinclusive = true
import UIKit

class PurchaseDetailDataLineViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView {
    
    @IBOutlet weak var PurchaseDetailDataLineTableView: UITableView!
    var originalRowsDic: [Int: String] = [0: "InventoryCell", 1: "AccountCell",2: "DescriptionCell",3: "QuantityCell",4: "UnitPriceCell",5: "TaxCodeCell",6: "AmountCell"]
    
    
    var strDescription = String()
    var purchasesTransactionsDetailView = PurchasesTransactionsDetailView()
    var purchasesTransactionHeader = PurchasesTransactionsHeader()
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    var selectedInventoryView = InventoryView?()
    var selectedAccountView = AccountView?()
    var supplier = Supplier?()
    
    var enableTaxCodeButton = true
    var reloadFromCell = ""
    override func viewWillAppear(animated: Bool) {
        
    }
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
            
            cell.lblInventoryName.text = purchasesTransactionsDetailView.InventoryName
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "AccountCell" {
            
            cell.accountButton.enabled = true
            enableTaxCodeButton = true
            if selectedInventoryView != nil {
                
                if selectedInventoryView!.IsBuy == true && selectedInventoryView!.IsInventory == false {
                    
                    
                    purchasesTransactionsDetailView.AccountID = selectedInventoryView?.PurchaseAccountID
                    purchasesTransactionsDetailView.AccountNameWithAccountNo = (selectedInventoryView?.PurchaseAccountNameWithAccountNo)!
                    
                    cell.accountButton.enabled = false
                    
                    //enableTaxCodeButton = false
                }
                if selectedInventoryView!.IsBuy == true && selectedInventoryView!.IsInventory == true {
                    
                    
                    purchasesTransactionsDetailView.AccountID = selectedInventoryView?.AssetAccountID
                    purchasesTransactionsDetailView.AccountNameWithAccountNo = (selectedInventoryView?.AssetAccountNameWithAccountNo)!
                    
                    cell.accountButton.enabled = false
                    // enableTaxCodeButton = false
                    
                }
                
                
            }
            
            
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
            
            // cell.taxCodeButton.enabled = true
            if selectedAccountView != nil {
                var TaxCodeID = selectedAccountView?.TaxCodeID
                
                if TaxCodeID != nil {
                    
                    if selectedAccountView?.TaxCodePurpose == "PayTax"
                    {
                        
                        
                        purchasesTransactionsDetailView.TaxCodeID = selectedAccountView?.TaxCodeID
                        purchasesTransactionsDetailView.TaxCodeRate = (selectedAccountView?.TaxRate)!
                        purchasesTransactionsDetailView.TaxCodeName = (selectedAccountView?.TaxCodeName)!
                        
                        // cell.taxCodeButton.enabled = false
                    }
                }
            }
            
            if selectedInventoryView != nil {
                
                var TaxCodeID = selectedInventoryView!.PurchaseTaxCodeID
                if TaxCodeID != nil {
                    
                    
                    purchasesTransactionsDetailView.TaxCodeID = selectedInventoryView?.PurchaseTaxCodeID
                    purchasesTransactionsDetailView.TaxCodeRate = selectedInventoryView!.PurchaseTaxCodeRate!
                    purchasesTransactionsDetailView.TaxCodeName = selectedInventoryView!.PurchaseTaxCodeName
                    
                    // cell.taxCodeButton.enabled = false
                }
            }
            
            if supplier != nil {
                
                var defaultTaxCodeID = supplier!.DefaultPurchasesTaxCodeID
                
                if defaultTaxCodeID != nil {
                    
                    
                    purchasesTransactionsDetailView.TaxCodeID = supplier?.DefaultPurchasesTaxCodeID
                    purchasesTransactionsDetailView.TaxCodeName = (supplier?.DefaultPurchasesTaxCodeName)!
                    purchasesTransactionsDetailView.TaxCodeRate = (supplier?.DefaultPurchasesTaxCodeRate)!
                    
                    //cell.taxCodeButton.enabled = false
                }
                
            }
            
            
            
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
        
        if resuseIdentifier == "UnitPriceCell" {
            
            if reloadFromCell == "InventoryCell"
            {
                if selectedInventoryView != nil {
                    
                    if purchasesTransactionHeader.TaxInclusive == true
                    {
                        
                        
                        if  selectedInventoryView?.IsPurchasePriceTaxInclusive == true {
                            
                            cell.lblUnitPrice.text = String(format: "%.4f", (selectedInventoryView?.PurchasePrice)!)
                            purchasesTransactionsDetailView.UnitPrice = (selectedInventoryView?.PurchasePrice)!
                        }
                        else {
                            
                            if selectedInventoryView?.PurchasePrice != nil {
                                var purchasePrice = (selectedInventoryView?.PurchasePrice)! as Double
                                
                                var purchasePriceTaxRate = selectedInventoryView?.PurchaseTaxCodeRate
                                purchasePrice = purchasePrice + purchasePrice * purchasePriceTaxRate! / 100
                                cell.lblUnitPrice.text = String(format: "%.4f", purchasePrice)
                                purchasesTransactionsDetailView.UnitPrice = purchasePrice
                            }
                            else {
                                print("nil")
                            }
                        }
                    }
                        
                    else {
                        
                        if  selectedInventoryView?.IsPurchasePriceTaxInclusive == true {
                            
                            var purchasePrice = (selectedInventoryView?.PurchasePrice)! as Double
                            
                            var purchasePriceTaxRate = selectedInventoryView?.PurchaseTaxCodeRate
                            purchasePrice = purchasePrice + purchasePrice * purchasePriceTaxRate! / 100
                            
                            var purchasePriceWithoutTax = purchasePrice*(1 - purchasePriceTaxRate!/100)
                            
                            cell.lblUnitPrice.text = String(format: "%.4f", purchasePriceWithoutTax)
                            purchasesTransactionsDetailView.UnitPrice = purchasePriceWithoutTax                        }
                        else {
                            
                            cell.lblUnitPrice.text = String(format: "%.4f", (selectedInventoryView?.PurchasePrice)!)
                            purchasesTransactionsDetailView.UnitPrice = (selectedInventoryView?.PurchasePrice)!
                        }
                        
                        
                        
                    }
                }
            }
            
            if reloadFromCell == "" {
                
                cell.lblUnitPrice.text = String(format: "%.2f", purchasesTransactionsDetailView.UnitPrice)
            }
        }
        
        
        if resuseIdentifier == "QuantityCell" {
            
            if reloadFromCell == "" {
                cell.lblQuantity.text = String(format: "%.2f", purchasesTransactionsDetailView.Quantity)
            }
            
            
            
        }
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
            
            if selectedInventoryView == nil
            {
                performSegueWithIdentifier("showAccount", sender: "AccountCell")
                
            }
        }
        
        
        if originalRowsDic[indexPath.row] == "TaxCodeCell" {
            if enableTaxCodeButton == true
            {
                performSegueWithIdentifier("showTaxCode", sender: "TaxCodeCell")
            }
            
            
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
    
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetailView: PurchasesTransactionsDetailView){
        
    }
    
    func sendGoBackFromPurchaseDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView){
        purchasesTransactionsDetailView.InventoryID = inventoryView.InventoryID
        purchasesTransactionsDetailView.InventoryName = inventoryView.InventoryName
        selectedInventoryView = inventoryView
        
        reloadFromCell = "InventoryCell"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
    func  sendGoBackFromPurchaseDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {
        purchasesTransactionsDetailView.Description = Description
        
        print("purchasesTransactionsDetailView.Description" + purchasesTransactionsDetailView.Description)
        
        reloadFromCell = "DescriptionCell"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
    
    func  sendGoBackFromPurchaseDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    {
        purchasesTransactionsDetailView.TaxCodeID = taxCodeView.TaxCodeID
        purchasesTransactionsDetailView.TaxCodeName = taxCodeView.TaxCodeName
        purchasesTransactionsDetailView.TaxCodeRate = taxCodeView.TaxRate
        
        reloadFromCell = "TaxCodeCell"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
    
    @IBAction func unitPriceEditingChanged(sender: AnyObject) {
        
        var UnitPriceTextField = sender as! UITextField
        var StrUnitPrice = UnitPriceTextField.text as String?
        
        if let UnitPrice = Double(StrUnitPrice!) {
            
            if UnitPrice >= 0 {
                //
                //
                //                if StrUnitPrice?.containsString(".") == true {
                //                    //Check decimal place whether less than 4
                //                    var strsplit = StrUnitPrice?.characters.split(("."))
                //                    let strLast = String(strsplit?.last!)
                //
                //
                //                    if strLast.length > 4 {
                //
                //
                //                        if UnitPrice == 0 {
                //                            UnitPriceTextField.text = "0.00"
                //                        } else {
                //                            //round to 4 decimal place
                //                            UnitPriceTextField.text =  String(format: "%.2f",Double(round(10000 * UnitPrice)/10000))
                //                        }
                //                    }
                //
                //
                //                }
                purchasesTransactionsDetailView.UnitPrice = UnitPrice
                
                
            }
            else {
                UnitPriceTextField.becomeFirstResponder()
                //                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input negative decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
                purchasesTransactionsDetailView.UnitPrice = 0
            }
        }
            
        else {
            
            if StrUnitPrice?.length > 0 {
                UnitPriceTextField.becomeFirstResponder()
                //                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can only input decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
                
                
            }
            purchasesTransactionsDetailView.UnitPrice = 0
        }
        purchasesTransactionsDetailView.Amount = purchasesTransactionsDetailView.UnitPrice * purchasesTransactionsDetailView.Quantity
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
                            UnitPriceTextField.text =  String(format: "%.4f",Double(round(10000 * UnitPrice)/10000))
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
    
    
    
    @IBAction func quantityEditingChanged(sender: AnyObject) {
        
        var QuantityTextField = sender as! UITextField
        var StrQuantity = QuantityTextField.text as String?
        
        if let Quantity = Double(StrQuantity!) {
            
            if Quantity != 0 {
                
                
                //                if StrQuantity?.containsString(".") == true {
                //                    //Check decimal place whether less than 4
                //                    var strsplit = StrQuantity?.characters.split(("."))
                //                    let strLast = String(strsplit?.last!)
                //
                //
                //                    if strLast.length > 4 {
                //
                //
                //                        if Quantity == 0 {
                //                            QuantityTextField.text = "0.00"
                //                        } else {
                //                            //round to 6 decimal place
                //                            QuantityTextField.text = String(Double(round(1000000 * Quantity)/1000000))
                //                        }
                //                    }
                //
                //
                //                }
                purchasesTransactionsDetailView.Quantity = Quantity
                
                
            }
            else {
                //                QuantityTextField.becomeFirstResponder()
                //                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input zero here!", viewController: self)
                
                QuantityTextField.text = ""
                purchasesTransactionsDetailView.Quantity = 0
            }
            
        }
        else {
            
            //            if StrQuantity?.length > 0 {
            //                QuantityTextField.becomeFirstResponder()
            //                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can only input decimal number here!", viewController: self)
            //
            //                QuantityTextField.text = ""
            //
            //            }
            purchasesTransactionsDetailView.Quantity = 0
        }
        purchasesTransactionsDetailView.Amount = purchasesTransactionsDetailView.UnitPrice * purchasesTransactionsDetailView.Quantity
        
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
        
        reloadFromCell = "calculateAmount"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.PurchaseDetailDataLineTableView.reloadData()
            
        })
    }
    func  sendGoBackFromPurchaseDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    {
        purchasesTransactionsDetailView.AccountID = accountView.AccountID
        purchasesTransactionsDetailView.AccountNameWithAccountNo = accountView.AccountNameWithAccountNo
        selectedAccountView = accountView
        //   var taxCodeView = getTaxCodeByTaxCodeID()
        
        reloadFromCell = "AccountCell"
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
        
        if validateQuantityValue() == true
        {
            if validateIfPurchaseTransactionsDetailViewIsEmpty() == false {
                calculateTaxAmount()
                self.delegate?.sendGoBackFromPurchaseDetailDataLineView("PurchaseDetailDataLineViewController", forCell: "AddanItemCell", purchasesTransactionsDetailView: purchasesTransactionsDetailView)
                navigationController?.popViewControllerAnimated(true)
            }
            else {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't add a purchase detail data line!", viewController: self)
            }
        }
        //        }
        //        else {
        //                 Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't add a purchase detail data line!", viewController: self)
        //        }
    }
    
    func calculateTaxAmount()
    {
        
        var amount = purchasesTransactionsDetailView.Amount
        
        if purchasesTransactionsDetailView.TaxCodeID != nil
        {
            var taxRate = purchasesTransactionsDetailView.TaxCodeRate! as Double
            
            var amountWithOutTax = 100*amount/(100 + taxRate)
            purchasesTransactionsDetailView.AmountWithoutTax = amountWithOutTax
        }
        else{
            purchasesTransactionsDetailView.AmountWithoutTax = purchasesTransactionsDetailView.Amount
        }
        
        //        if purchasesTransactionsDetailView.InventoryID != nil
        //        {
        //            if selectedInventoryView != nil {
        //                if selectedInventoryView?.IsPurchasePriceTaxInclusive == true {
        //
        //                    var  purchasePrice = (selectedInventoryView?.PurchasePrice)! as Double
        //
        //                    var quantity = purchasesTransactionsDetailView.Quantity
        //
        //
        //                    //
        //                }
        //            }
        //        }
        //            if selectedInventoryView != nil {
        //
        //                if  selectedInventoryView?.IsPurchasePriceTaxInclusive == true {
        //
        //                    cell.lblUnitPrice.text = String(format: "%.2f", (selectedInventoryView?.PurchasePrice)!)
        //                    purchasesTransactionsDetailView.UnitPrice = (selectedInventoryView?.PurchasePrice)!
        //                }
        //                else {
        //
        //                    if selectedInventoryView?.PurchasePrice != nil {
        //                        var purchasePrice = (selectedInventoryView?.PurchasePrice)! as Double
        //
        //                        var purchasePriceTaxRate = selectedInventoryView?.PurchaseTaxCodeRate
        //                        purchasePrice = purchasePrice + purchasePrice * purchasePriceTaxRate! / 100
        //                        cell.lblUnitPrice.text = String(format: "%.2f", purchasePrice)
        //                        purchasesTransactionsDetailView.UnitPrice = purchasePrice
        //                    }
        
        
    }
    func validateQuantityValue() -> Bool
    {
        if purchasesTransactionHeader.PurchasesType == "DEBIT NOTE"
        {
            if  purchasesTransactionsDetailView.Quantity > 0
            {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input positive amount at quantity field when purchase type is DEBIT NOTE!", viewController: self)
                return false
            }
        }
        else {
            if  purchasesTransactionsDetailView.Quantity < 0
            {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input negative amount at quantity field when purchase type is QUOTE,ORDER ,BILL!", viewController: self)
                return false
            }
            
        }
        
        return true
    }
    func validateIfPurchaseTransactionsDetailViewIsEmpty() -> Bool
    {
        var isEmpty = false
        if purchasesTransactionsDetailView.InventoryID == nil && purchasesTransactionsDetailView.AccountID == nil {
            
            isEmpty = true
        }
        if purchasesTransactionsDetailView.Amount == 0
        {
            isEmpty = true
        }
        
        return isEmpty
    }
    func  sendGoBackFromPurchaseDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {
        
    }
    
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
      func  sendGoBackFromContactSearchView(fromView : String ,forCell: String,Contact: Customer)
      {}
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
