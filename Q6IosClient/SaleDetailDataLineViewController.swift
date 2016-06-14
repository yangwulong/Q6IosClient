//
//  SaleDetailDataLineViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailDataLineViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView {

    
    @IBOutlet weak var SaleDetailDataLineTableView: UITableView!
    var originalRowsDic: [Int: String] = [0: "InventoryCell", 1: "AccountCell",2: "DescriptionCell",3: "QuantityCell",4: "UnitPriceCell",5: "TaxCodeCell",6: "AmountCell"]
    
    
    var strDescription = String()
    var salesTransactionsDetailView = SalesTransactionsDetailView()
    var salesTransactionHeader = SalesTransactionsHeader()
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    var selectedInventoryView = InventoryView?()
    var selectedAccountView = AccountView?()
    var selectedTaxCodeView = TaxCodeView?()
    var customer = Customer?()
    
    var enableTaxCodeButton = true
    var reloadFromCell = ""
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SaleDetailDataLineTableView.delegate = self
        SaleDetailDataLineTableView.dataSource = self
        // Do any additional setup after loading the view.
        setControlAppear()
    }
    
    
    func setControlAppear()
    {
        // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        
        SaleDetailDataLineTableView.tableFooterView = UIView(frame: CGRectZero)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! SaleDetailDataLineTableViewCell
        //
        
        //
        
        if resuseIdentifier == "InventoryCell" {
            
            
            // print("purchasesTransactionsDetailView.AccountNameWithAccountNo" + purchasesTransactionsDetailView.AccountNameWithAccountNo)
            
            cell.lblInventoryName.text = salesTransactionsDetailView.InventoryName
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "AccountCell" {
            
            cell.accountButton.enabled = true
            enableTaxCodeButton = true
            if selectedInventoryView != nil {
                
                if selectedInventoryView!.IsBuy == true && selectedInventoryView!.IsInventory == false {
                    
                    
                    salesTransactionsDetailView.AccountID = selectedInventoryView?.PurchaseAccountID
                    salesTransactionsDetailView.AccountNameWithAccountNo = (selectedInventoryView?.PurchaseAccountNameWithAccountNo)!
                    
                    cell.accountButton.enabled = false
                    
                    //enableTaxCodeButton = false
                }
                if selectedInventoryView!.IsBuy == true && selectedInventoryView!.IsInventory == true {
                    
                    
                    salesTransactionsDetailView.AccountID = selectedInventoryView?.AssetAccountID
                    salesTransactionsDetailView.AccountNameWithAccountNo = (selectedInventoryView?.AssetAccountNameWithAccountNo)!
                    
                    cell.accountButton.enabled = false
                    // enableTaxCodeButton = false
                    
                }
                
                
            }
            
            
            cell.lblAccountNameWithNo.text = salesTransactionsDetailView.AccountNameWithAccountNo
            
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "DescriptionCell" {
            
            
            
            cell.lblDescription.text = salesTransactionsDetailView.Description
            
            
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
                        
                        
                        salesTransactionsDetailView.TaxCodeID = selectedAccountView?.TaxCodeID
                        salesTransactionsDetailView.TaxCodeRate = (selectedAccountView?.TaxRate)!
                        salesTransactionsDetailView.TaxCodeName = (selectedAccountView?.TaxCodeName)!
                        
                        // cell.taxCodeButton.enabled = false
                    }
                }
            }
            
            if selectedInventoryView != nil {
                
                var TaxCodeID = selectedInventoryView!.SaleTaxCodeID
                if TaxCodeID != nil {
                    
                    
                    salesTransactionsDetailView.TaxCodeID = selectedInventoryView?.SaleTaxCodeID
                    salesTransactionsDetailView.TaxCodeRate = selectedInventoryView!.SaleTaxCodeRate!
                    salesTransactionsDetailView.TaxCodeName = selectedInventoryView!.SaleTaxCodeName
                    
                    // cell.taxCodeButton.enabled = false
                }
            }
            
            if customer != nil {
                
                var defaultTaxCodeID = customer!.DefaultSalesTaxCodeID
                
                if defaultTaxCodeID != nil {
                    
                    
                    salesTransactionsDetailView.TaxCodeID = customer?.DefaultSalesTaxCodeID
                    salesTransactionsDetailView.TaxCodeName = (customer?.DefaultSalesTaxCodeName)!
                    salesTransactionsDetailView.TaxCodeRate = (customer?.DefaultSalesTaxCodeRate)!
                    
                    //cell.taxCodeButton.enabled = false
                }
                
            }
            if selectedTaxCodeView != nil {
                
                salesTransactionsDetailView.TaxCodeID = selectedTaxCodeView?.TaxCodeID
                salesTransactionsDetailView.TaxCodeName = (selectedTaxCodeView?.TaxCodeName)!
                salesTransactionsDetailView.TaxCodeRate = (selectedTaxCodeView?.TaxRate)!
            }
            
            
            
            cell.lblTaxCodeName.text = salesTransactionsDetailView.TaxCodeName
            
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "AmountCell" {
            
            
            var amount = salesTransactionsDetailView.Amount
            
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
                    
                    if salesTransactionHeader.TaxInclusive == true
                    {
                        
                        
                        if  selectedInventoryView?.IsSalePriceTaxInclusive == true {
                            
                            cell.lblUnitPrice.text = String(format: "%.4f", (selectedInventoryView?.SellingPrice)!)
                            salesTransactionsDetailView.UnitPrice = (selectedInventoryView?.SellingPrice)!
                        }
                        else {
                            
                            if selectedInventoryView?.SellingPrice != nil {
                                var salePrice = (selectedInventoryView?.SellingPrice)! as Double
                                
                                var salePriceTaxRate = selectedInventoryView?.SaleTaxCodeRate
                                salePrice = salePrice + salePrice * salePriceTaxRate! / 100
                                cell.lblUnitPrice.text = String(format: "%.4f", salePrice)
                                salesTransactionsDetailView.UnitPrice = salePrice
                            }
                            else {
                                print("nil")
                            }
                        }
                    }
                        
                    else {
                        
                        if  selectedInventoryView?.IsSalePriceTaxInclusive == true {
                            
                            var salePrice = (selectedInventoryView?.SellingPrice)! as Double
                            
                            var salePriceTaxRate = selectedInventoryView?.SaleTaxCodeRate
                            salePrice = salePrice + salePrice * salePriceTaxRate! / 100
                            
                            var salePriceWithoutTax = salePrice*(1 - salePriceTaxRate!/100)
                            
                            cell.lblUnitPrice.text = String(format: "%.4f", salePriceWithoutTax)
                            salesTransactionsDetailView.UnitPrice = salePriceWithoutTax                        }
                        else {
                            
                            cell.lblUnitPrice.text = String(format: "%.4f", (selectedInventoryView?.SellingPrice)!)
                            salesTransactionsDetailView.UnitPrice = (selectedInventoryView?.SellingPrice)!
                        }
                        
                        
                        
                    }
                }
            }
            
            if reloadFromCell == "" {
                
                cell.lblUnitPrice.text = String(format: "%.2f", salesTransactionsDetailView.UnitPrice)
            }
        }
        
        
        if resuseIdentifier == "QuantityCell" {
            
            if reloadFromCell == "" {
                cell.lblQuantity.text = String(format: "%.2f", salesTransactionsDetailView.Quantity)
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
                var saleDetailDataLineInventorySearchViewController = segue.destinationViewController as! SaleDetailDataLineInventorySearchViewController
                saleDetailDataLineInventorySearchViewController.fromCell = "InventoryCell"
                
                saleDetailDataLineInventorySearchViewController.delegate = self
                
                selectedAccountView = nil
                selectedTaxCodeView = nil
                
            }
            
            if fromCell == "AccountCell"
            {
                var saleDetailDataLineAccountSearchViewController = segue.destinationViewController as! SaleDetailDataLineAccountSearchViewController
                
                saleDetailDataLineAccountSearchViewController.fromCell = "AccountCell"
                
                saleDetailDataLineAccountSearchViewController.delegate = self
                
                selectedTaxCodeView = nil
            }
            
            if fromCell == "TaxCodeCell"
            {
                var saleDetailDataLineTaxCodeSearchViewController = segue.destinationViewController as! SaleDetailDataLineTaxCodeSearchViewController
                
                saleDetailDataLineTaxCodeSearchViewController.fromCell = "TaxCodeCell"
                
                saleDetailDataLineTaxCodeSearchViewController.delegate = self
            }
            if fromCell == "DescriptionCell"
            {
                var saleDetailDataLineDescription = segue.destinationViewController as! SaleDetailDataLineDescriptionViewController
                
                saleDetailDataLineDescription.fromCell = "DescriptionCell"
                
                saleDetailDataLineDescription.delegate = self
                saleDetailDataLineDescription.textValue = salesTransactionsDetailView.Description
            }
        }
    }
    
    func  sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String){
        
    }
    
    func  sendGoBackFromSupplierSearchView(fromView : String ,forCell: String,Contact: Supplier){
        
    }
    
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate){
        
    }
    
    func sendGoBackFromSaleDetailDataLineView(fromView:String,forCell:String,salesTransactionsDetailView: SalesTransactionsDetailView){
        
    }
    
    func sendGoBackFromSaleDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView){
        salesTransactionsDetailView.InventoryID = inventoryView.InventoryID
        salesTransactionsDetailView.InventoryName = inventoryView.InventoryName
        selectedInventoryView = inventoryView
        
        reloadFromCell = "InventoryCell"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.SaleDetailDataLineTableView.reloadData()
            
        })
    }
    func  sendGoBackFromSaleDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {
        salesTransactionsDetailView.Description = Description
        
        print("salesTransactionsDetailView.Description" + salesTransactionsDetailView.Description)
        
        reloadFromCell = "DescriptionCell"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.SaleDetailDataLineTableView.reloadData()
            
        })
    }
    
    func  sendGoBackFromSaleDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    {
        salesTransactionsDetailView.TaxCodeID = taxCodeView.TaxCodeID
        salesTransactionsDetailView.TaxCodeName = taxCodeView.TaxCodeName
        salesTransactionsDetailView.TaxCodeRate = taxCodeView.TaxRate
        
        selectedTaxCodeView = taxCodeView
        reloadFromCell = "TaxCodeCell"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.SaleDetailDataLineTableView.reloadData()
            
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
                salesTransactionsDetailView.UnitPrice = UnitPrice
                
                
            }
            else {
                UnitPriceTextField.becomeFirstResponder()
                //                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input negative decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
                salesTransactionsDetailView.UnitPrice = 0
            }
        }
            
        else {
            
            if StrUnitPrice?.length > 0 {
                UnitPriceTextField.becomeFirstResponder()
                //                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can only input decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
                
                
            }
            salesTransactionsDetailView.UnitPrice = 0
        }
        salesTransactionsDetailView.Amount = salesTransactionsDetailView.UnitPrice * salesTransactionsDetailView.Quantity
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
                            UnitPriceTextField.text = "0.0000"
                        } else {
                            //round to 4 decimal place
                            UnitPriceTextField.text =  String(format: "%.4f",Double(round(10000 * UnitPrice)/10000))
                        }
                    }
                    
                    
                }
                salesTransactionsDetailView.UnitPrice = UnitPrice
                
                
            }
            else {
                UnitPriceTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input negative decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
                salesTransactionsDetailView.UnitPrice = 0
            }
            
        }
        else {
            
            if StrUnitPrice?.length > 0 {
                UnitPriceTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can only input decimal number here!", viewController: self)
                
                UnitPriceTextField.text = ""
                
                
            }
            salesTransactionsDetailView.UnitPrice = 0
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
                salesTransactionsDetailView.Quantity = Quantity
                
                
            }
            else {
                //                QuantityTextField.becomeFirstResponder()
                //                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input zero here!", viewController: self)
                
                QuantityTextField.text = ""
                salesTransactionsDetailView.Quantity = 0
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
            salesTransactionsDetailView.Quantity = 0
        }
        salesTransactionsDetailView.Amount = salesTransactionsDetailView.UnitPrice * salesTransactionsDetailView.Quantity
        
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
                salesTransactionsDetailView.Quantity = Quantity
                
                
            }
            else {
                QuantityTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can not input zero here!", viewController: self)
                
                QuantityTextField.text = ""
                salesTransactionsDetailView.Quantity = 0
            }
            
        }
        else {
            
            if StrQuantity?.length > 0 {
                QuantityTextField.becomeFirstResponder()
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You can only input decimal number here!", viewController: self)
                
                QuantityTextField.text = ""
                
            }
            salesTransactionsDetailView.Quantity = 0
        }
        calculateAmount()
    }
    func calculateAmount()
    {
        salesTransactionsDetailView.Amount = salesTransactionsDetailView.UnitPrice * salesTransactionsDetailView.Quantity
        
        reloadFromCell = "calculateAmount"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.SaleDetailDataLineTableView.reloadData()
            
        })
    }
    func  sendGoBackFromSaleDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    {
        salesTransactionsDetailView.AccountID = accountView.AccountID
        salesTransactionsDetailView.AccountNameWithAccountNo = accountView.AccountNameWithAccountNo
        selectedAccountView = accountView
        //   var taxCodeView = getTaxCodeByTaxCodeID()
        
        reloadFromCell = "AccountCell"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.SaleDetailDataLineTableView.reloadData()
            
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
            if validateIfSaleTransactionsDetailViewIsEmpty() == false {
                calculateTaxAmount()
                self.delegate?.sendGoBackFromSaleDetailDataLineView("SaleDetailDataLineViewController", forCell: "AddanItemCell", salesTransactionsDetailView: salesTransactionsDetailView)
                navigationController?.popViewControllerAnimated(true)
            }
            else {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't add a sale detail data line!", viewController: self)
            }
        }
        //        }
        //        else {
        //                 Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't add a purchase detail data line!", viewController: self)
        //        }
    }
    
    func calculateTaxAmount()
    {
        
        var amount = salesTransactionsDetailView.Amount
        
        if salesTransactionsDetailView.TaxCodeID != nil
        {
            var taxRate = salesTransactionsDetailView.TaxCodeRate! as Double
            
            var amountWithOutTax = 100*amount/(100 + taxRate)
            salesTransactionsDetailView.AmountWithoutTax = amountWithOutTax
        }
        else{
            salesTransactionsDetailView.AmountWithoutTax = salesTransactionsDetailView.Amount
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
        if salesTransactionHeader.SalesType == "CREDIT NOTE"
        {
            if  salesTransactionsDetailView.Quantity > 0
            {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input positive amount at quantity field when sale type is CREDIT NOTE!", viewController: self)
                return false
            }
        }
        else {
            if  salesTransactionsDetailView.Quantity < 0
            {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input negative amount at quantity field when purchase type is QUOTE,ORDER ,INVOICE!", viewController: self)
                return false
            }
            
        }
        
        return true
    }
    func validateIfSaleTransactionsDetailViewIsEmpty() -> Bool
    {
        var isEmpty = false
        if salesTransactionsDetailView.InventoryID == nil && salesTransactionsDetailView.AccountID == nil {
            
            isEmpty = true
        }
        if salesTransactionsDetailView.Amount == 0
        {
            isEmpty = true
        }
        
        return isEmpty
    }
    func  sendGoBackFromPurchaseDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {
        
    }
    
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
    
    func  sendGoBackFromSaleDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {}
    func  sendGoBackFromCustomerSearchView(fromView : String ,forCell: String,Contact: Customer)
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
