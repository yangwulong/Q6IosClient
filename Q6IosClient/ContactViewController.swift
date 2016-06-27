//
//  ContactViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 15/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol ,UITextViewDelegate{
    var originalRowsDic: [Int: String] = [0: "ContactNameCell", 1: "PhoneCell",2: "EmailCell",3: "MemoCell"]
    
    @IBOutlet weak var btnSaveButton: UIBarButtonItem!
    @IBOutlet weak var btnCancelButton: UIBarButtonItem!
    var Memo = UITextView()
    var OperationType = String()
    var ContactType = String()
    var ContactID = String?()
    var isPreLoad = false
    var supplier = Supplier()
    var customer = Customer()
    var CallButton = UIButton?()
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var ContactTableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    weak var delegate2: Q6GoBackFromViewTwo?
    override func viewWillAppear(animated: Bool) {
        Q6ActivityIndicatorView.hidesWhenStopped = true
        Q6ActivityIndicatorView.stopAnimating()
        if ContactType == "Supplier"
        {
        
       navigationBar.topItem?.title = "Supplier"
        }
        else{
             navigationBar.topItem?.title = "Customer"
        }
        if OperationType == "Edit"
        {
            if ContactType == "Supplier"
            {
                
                
                Q6ActivityIndicatorView.startAnimating()
                let q6CommonLib = Q6CommonLib(myObject: self)
                
                let attachedURL = "&SupplierID=" + ContactID!
                isPreLoad = true
                q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierByID", attachedURL: attachedURL)
                
            }
            
            if ContactType == "Customer"
            {
                
                
                Q6ActivityIndicatorView.startAnimating()
                let q6CommonLib = Q6CommonLib(myObject: self)
                
                let attachedURL = "&CustomerID=" + ContactID!
                isPreLoad = true
                q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerByID", attachedURL: attachedURL)
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContactTableView.delegate = self
        ContactTableView.dataSource = self
        setControlAppear()
        // Do any additional setup after loading the view.
        //Memo.delegate = self
        print("OperationType" + OperationType)
        print("ContactType" + ContactType)
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
            
            Memo = cell.lblMemo
            Memo.delegate = self
            
            if ContactType == "Supplier" {
            cell.lblMemo.text = supplier.Memos
            }
            else {
                cell.lblMemo.text = customer.Memos
            }
            //  cell.lblContactName.text = "Supplier Name"
        }
        if resuseIdentifier == "PhoneCell" {
            
            CallButton = cell.btnCallButton
            
            if ContactType == "Supplier"{
                 cell.txtPhone.text = supplier.Phone
                if supplier.Phone?.length == 0 {
                    CallButton?.enabled = false
                }
                else {
                    CallButton?.enabled = true
                }
            }
            
            if ContactType == "Customer"{
                cell.txtPhone.text = customer.Phone
                if customer.Phone?.length == 0 {
                    CallButton?.enabled = false
                }
                else {
                    CallButton?.enabled = true
                }
            }
          
            //  cell.lblContactName.text = "Supplier Name"
        }
        
           if resuseIdentifier == "ContactNameCell" {
           if ContactType == "Supplier"
           {
            cell.txtContactName.text = supplier.SupplierName
            }
           else {
            cell.txtContactName.text = customer.CustomerName
            }
        }
        
        if resuseIdentifier == "EmailCell" {
            if ContactType == "Supplier"
            {
                cell.txtEmail.text = supplier.Email
            }
            else {
                 cell.txtEmail.text = customer.Email
            }
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
        
        if isPreLoad == true && OperationType == "Edit" && ContactType == "Supplier" {
            
            
            var postDicData :[String:AnyObject]
            
            do {
            
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                let returnData = postDicData["Supplier"] as! [String : AnyObject]
                print("returnDate Count" + returnData.count.description)
//                for i in 0  ..< returnData.count {
                      var dataItem = returnData  //[i]
                    supplier.ABN = dataItem["ABN"] as? String
                 supplier.BankAccountName = dataItem["BankAccountName"] as? String
                    supplier.BankAccountNumber = dataItem["BankAccountNumber"] as? String
                    supplier.BSBNumber = dataItem["BSBNumber"] as? String
                
                    
                    let CreateDate = dataItem["CreateDate"] as? String
                    //                var convertDueDate = NSDate?()
                    //                if dueDate != nil {
                    //                print("dueDate sss" + dueDate!)
                    //
                    //                    convertDueDate = dueDate?.toDateTime()
                    //
                    //
                print(" Create Date" + CreateDate!)
                    supplier.CreateDate = (CreateDate?.toDateTime())!
                    
                  print("Supplier Create Date" + supplier.CreateDate.description)
                    
                    let DefaultPurchasesAccountID = dataItem["DefaultPurchasesAccountID"] as? String
                    
                    if DefaultPurchasesAccountID != nil {
                       supplier.DefaultPurchasesAccountID = DefaultPurchasesAccountID!
                    }
                 
                    
                    supplier.DefaultPurchasesAccountNameWithAccountNo = dataItem["DefaultPurchasesAccountNameWithAccountNo"] as? String
                    
                    
                    let DefaultPurchasesTaxCodeID = dataItem["DefaultPurchasesTaxCodeID"] as? String
                    
                    if DefaultPurchasesTaxCodeID != nil {
                    supplier.DefaultPurchasesTaxCodeID = DefaultPurchasesTaxCodeID!                     }
                    supplier.DefaultPurchasesTaxCodeName = dataItem["DefaultPurchasesTaxCodeName"] as! String
                    
                    supplier.DefaultPurchasesTaxCodePurpose = dataItem["DefaultPurchasesTaxCodePurpose"] as! String
                    
                    supplier.DefaultPurchasesTaxCodeRate = dataItem["DefaultPurchasesTaxCodeRate"] as! Double
                    let Email = dataItem["Email"] as? String
                    
                    if Email != nil {
                     supplier.Email = Email!
                    }
                 
                    
                    supplier.Fax = dataItem["Fax"] as? String
                    supplier.FirstName = dataItem["FirstName"] as? String
                    supplier.IsInactive = dataItem["IsInactive"] as! Bool
                    supplier.IsSameAsPhysicalAddress = dataItem["IsSameAsPhysicalAddress"] as? Bool
                    supplier.IsSameAsPostalAddress = dataItem["IsSameAsPostalAddress"] as? Bool
                    supplier.LastName = dataItem["LastName"] as? String
                    supplier.Memos = dataItem["Memos"] as? String
                    supplier.PaymentMemos = dataItem["PaymentMemos"] as? String
                    supplier.Phone = dataItem["Phone"] as? String
                    
                    supplier.PhysicalAddress = dataItem["PhysicalAddress"] as? String
                    supplier.PhysicalAddressLine2 = dataItem["PhysicalAddressLine2"] as? String
                    supplier.PhysicalCity = dataItem["PhysicalCity"] as? String
                    supplier.PhysicalCountry = dataItem["PhysicalCountry"] as? String
                    supplier.PhysicalPostalCode = dataItem["PhysicalPostalCode"] as? String
                    supplier.PhysicalState = dataItem["PhysicalState"] as? String
                    
                    
                    supplier.PostalAddress = dataItem["PostalAddress"] as? String
                    supplier.PostalAddressLine2 = dataItem["PostalAddressLine2"] as? String
                    supplier.PostalCity = dataItem["PostalCity"] as? String
                    supplier.PostalCountry = dataItem["PostalCountry"] as? String
                    supplier.PostalPostalCode = dataItem["PostalPostalCode"] as? String
                    supplier.PostalState = dataItem["PostalState"] as? String
                    
                    supplier.ShippingAddress = dataItem["ShippingAddress"] as? String
                    supplier.ShippingAddressLine2 = dataItem["ShippingAddressLine2"] as? String
                    supplier.ShippingCity = dataItem["ShippingCity"] as? String
                    supplier.ShippingCountry = dataItem["ShippingCountry"] as? String
                    supplier.ShippingPostalCode = dataItem["ShippingPostalCode"] as? String
                    supplier.ShippingState = dataItem["ShippingState"] as? String
                    
                    supplier.StatementText = dataItem["StatementText"] as? String
                    
                    supplier.SupplierID = dataItem["SupplierID"] as! String
                    
                    supplier.SupplierName = dataItem["SupplierName"] as! String
                    
                     supplier.Title = dataItem["Title"] as? String
                     //supplier.SupplierName = dataItem["SupplierName"] as! String
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                self.ContactTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
                }
                
            }
            catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
        }
        else if isPreLoad == true && OperationType == "Edit" && ContactType == "Customer" {
            
            
            var postDicData :[String:AnyObject]
            
            do {
                
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                let returnData = postDicData["Customer"] as! [String : AnyObject]
                print("returnDate Count" + returnData.count.description)
                //                for i in 0  ..< returnData.count {
                var dataItem = returnData  //[i]
                customer.ABN = dataItem["ABN"] as? String
                customer.BankAccountName = dataItem["BankAccountName"] as? String
                customer.BankAccountNumber = dataItem["BankAccountNumber"] as? String
                customer.BSBNumber = dataItem["BSBNumber"] as? String
                
                
                let CreateDate = dataItem["CreateDate"] as? String
                //                var convertDueDate = NSDate?()
                //                if dueDate != nil {
                //                print("dueDate sss" + dueDate!)
                //
                //                    convertDueDate = dueDate?.toDateTime()
                //
                //
                customer.CreateDate = (CreateDate?.toDateTime())!
                print(" Create Date" + CreateDate!)
                print("Customer Create Date" + customer.CreateDate.description)
                
                let DefaultSalesAccountID = dataItem["DefaultSalesAccountID"] as? String
                
                if DefaultSalesAccountID != nil {
                    customer.DefaultSalesAccountID = DefaultSalesAccountID!
                }
                
                
                customer.DefaultSalesAccountNameWithAccountNo = dataItem["DefaultSalesAccountNameWithAccountNo"] as? String
                
                
                let DefaultSalesTaxCodeID = dataItem["DefaultSalesTaxCodeID"] as? String
                
                if DefaultSalesTaxCodeID != nil {
                    customer.DefaultSalesTaxCodeID = DefaultSalesTaxCodeID!                     }
                customer.DefaultSalesTaxCodeName = dataItem["DefaultSalesTaxCodeName"] as! String
                
                customer.DefaultSalesTaxCodePurpose = dataItem["DefaultSalesTaxCodePurpose"] as! String
                
                customer.DefaultSalesTaxCodeRate = dataItem["DefaultSalesTaxCodeRate"] as! Double
                let Email = dataItem["Email"] as? String
                
                if Email != nil {
                    customer.Email = Email!
                }
                
                
                customer.Fax = dataItem["Fax"] as? String
                customer.FirstName = dataItem["FirstName"] as? String
                customer.IsInactive = dataItem["IsInactive"] as! Bool
                customer.IsSameAsPhysicalAddress = dataItem["IsSameAsPhysicalAddress"] as? Bool
                customer.IsSameAsPostalAddress = dataItem["IsSameAsPostalAddress"] as? Bool
                customer.LastName = dataItem["LastName"] as? String
                customer.Memos = dataItem["Memos"] as? String
                customer.PaymentMemos = dataItem["PaymentMemos"] as? String
                customer.Phone = dataItem["Phone"] as? String
                
                customer.PhysicalAddress = dataItem["PhysicalAddress"] as? String
                customer.PhysicalAddressLine2 = dataItem["PhysicalAddressLine2"] as? String
                customer.PhysicalCity = dataItem["PhysicalCity"] as? String
                customer.PhysicalCountry = dataItem["PhysicalCountry"] as? String
                customer.PhysicalPostalCode = dataItem["PhysicalPostalCode"] as? String
                customer.PhysicalState = dataItem["PhysicalState"] as? String
                
                
                customer.PostalAddress = dataItem["PostalAddress"] as? String
                customer.PostalAddressLine2 = dataItem["PostalAddressLine2"] as? String
                customer.PostalCity = dataItem["PostalCity"] as? String
                customer.PostalCountry = dataItem["PostalCountry"] as? String
                customer.PostalPostalCode = dataItem["PostalPostalCode"] as? String
                customer.PostalState = dataItem["PostalState"] as? String
                
                customer.ShippingAddress = dataItem["ShippingAddress"] as? String
                customer.ShippingAddressLine2 = dataItem["ShippingAddressLine2"] as? String
                customer.ShippingCity = dataItem["ShippingCity"] as? String
                customer.ShippingCountry = dataItem["ShippingCountry"] as? String
                customer.ShippingPostalCode = dataItem["ShippingPostalCode"] as? String
                customer.ShippingState = dataItem["ShippingState"] as? String
                
                customer.StatementText = dataItem["StatementText"] as? String
                
                customer.CustomerID = dataItem["CustomerID"] as! String
                
                customer.CustomerName = dataItem["CustomerName"] as! String
                
                customer.Title = dataItem["Title"] as? String
                //supplier.SupplierName = dataItem["SupplierName"] as! String
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.ContactTableView.reloadData()
                    self.Q6ActivityIndicatorView.hidesWhenStopped = true
                    self.Q6ActivityIndicatorView.stopAnimating()
                }
                
            }
            catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
        }

        else if isPreLoad == false   {
        var postDicData :[String:AnyObject]
        var _ : Bool
        do {
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            
            let IsSuccessed = postDicData["IsSuccessed"] as! Bool
            
            
            if IsSuccessed == true {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    // let all subview control resignfirstresponse()
                    self.view.endEditing(true)
                    
                }
                
                _ = navigationController
                // Q6CommonLib.q6UIAlertPopupControllerThenGoBack("Information message", message: "Save Successfully!", viewController: self,timeArrange:3,navigationController: nav!)
                
                
                let alert = UIAlertController(title: "Information message", message: "Save Successfully!", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
                let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                                              Int64(3 * Double(NSEC_PER_SEC)))
                let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
                                               Int64(4 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil);
                    
                    // self.navigationController!.popViewControllerAnimated(true)
                    // self.navigationController?.popToRootViewControllerAnimated(true)
                }
                dispatch_after(delayTime2, dispatch_get_main_queue()) {
                    // self.dismissViewControllerAnimated(true, completion: nil);
                    self.delegate2?.sendGoBackContactDetailView("ContactViewController", fromButton: "Save")
                    self.navigationController!.popViewControllerAnimated(true)
                    // self.navigationController?.popToRootViewControllerAnimated(true)
                }
                
            }else {
                
                let alert = UIAlertController(title: "Information message", message: "Save Fail!", preferredStyle: UIAlertControllerStyle.Alert)
                
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.btnSaveButton.enabled = true
                    self.btnCancelButton.enabled = true
                    
                }
                
               
                
            }
        } catch  {
            print("error parsing response from POST on /posts")
            btnSaveButton.enabled = true
            btnCancelButton.enabled = true
            return ""
        }
        
        }
        return ""
    }
    
    @IBAction func SaveButtonClick(sender: AnyObject) {
        
        isPreLoad = false
        
        var dicData=[String:AnyObject]()
        
        
        let q6DBLib = Q6DBLib()
        let q6CommonLib = Q6CommonLib(myObject: self)
        var userInfos = q6DBLib.getUserInfos()
        
        let LoginDetail = InternalUserLoginParameter()
        
        LoginDetail.LoginUserName = userInfos["LoginEmail"]!
        LoginDetail.Password = userInfos["PassWord"]!
        LoginDetail.ClientIP = Q6CommonLib.getIPAddresses()
        LoginDetail.WebApiTOKEN = Q6CommonLib.getQ6WebAPIToken()
        
        
        
        
        
        var LoginDetailDicData = [String:AnyObject]()
        
        LoginDetailDicData["Email"] = userInfos["LoginEmail"]!
        LoginDetailDicData["Password"] = userInfos["PassWord"]!
        LoginDetailDicData["CompanyID"] = userInfos["CompanyID"]!
        LoginDetailDicData["WebApiTOKEN"] = Q6CommonLib.getQ6WebAPIToken()
        
        dicData["LoginDetail"] = LoginDetailDicData
        dicData["NeedValidate"] = false
        
       
        
        if ContactType == "Supplier" {
            
            if supplier.SupplierName.length == 0 {
                
                Q6CommonLib.q6UIAlertPopupController("Information Message", message:" Supplier Name can not be empty!", viewController: self)
            }
            else if supplier.Email?.length>0 &&  Q6CommonLib.isEmailAddressValid(supplier.Email!) == false {
                 Q6CommonLib.q6UIAlertPopupController("Information Message", message:" Email Address is not valid !", viewController: self)
            }
            else {dicData["Supplier"] = convertSupplierToArray()
                
                
            if OperationType == "Create" {
                
                  q6CommonLib.Q6IosClientPostAPI("Purchase",ActionName: "AddSupplier", dicData:dicData)
            }
            else if OperationType == "Edit" {
                
                    q6CommonLib.Q6IosClientPostAPI("Purchase",ActionName: "EditSupplier", dicData:dicData)
                }
                
                btnSaveButton.enabled = false
                btnCancelButton.enabled = false
            }
        }
        
        
        if ContactType == "Customer" {
            
            if customer.CustomerName.length == 0 {
                
                Q6CommonLib.q6UIAlertPopupController("Information Message", message:" Customer Name can not be empty!", viewController: self)
            }
            else if customer.Email?.length>0 &&  Q6CommonLib.isEmailAddressValid(customer.Email!) == false {
                Q6CommonLib.q6UIAlertPopupController("Information Message", message:" Email Address is not valid !", viewController: self)
            }
            else {
                dicData["Customer"] = convertCustomerToArray()
                
                
                if OperationType == "Create" {
                    
                    q6CommonLib.Q6IosClientPostAPI("Sale",ActionName: "AddCustomer", dicData:dicData)
                }
                else if OperationType == "Edit" {
                    
                    q6CommonLib.Q6IosClientPostAPI("Sale",ActionName: "EditCustomer", dicData:dicData)
                }
                btnSaveButton.enabled = false
                btnCancelButton.enabled = false
            }
        }
       
    }

    @IBAction func CancelButtonClick(sender: AnyObject) {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func convertSupplierToArray() -> [String: AnyObject]
    {
        var dicData = [String: AnyObject]()
        
       dicData["ABN"] =  supplier.ABN
        dicData["BankAccountName"] =  supplier.BankAccountName
        
        dicData["BankAccountNumber"] =  supplier.BankAccountNumber
        
        dicData["BSBNumber"] =  supplier.BSBNumber
        dicData["CreateDate"] =  supplier.CreateDate.description
        dicData["DefaultPurchasesAccountID"] =  supplier.DefaultPurchasesAccountID
       // dicData["DefaultPurchasesAccountNameWithAccountNo"] =  supplier.DefaultPurchasesAccountNameWithAccountNo
        dicData["DefaultPurchasesTaxCodeID"] =  supplier.DefaultPurchasesTaxCodeID
        dicData["Email"] =  supplier.Email
        dicData["Fax"] =  supplier.Fax
        dicData["FirstName"] =  supplier.FirstName
        dicData["IsInactive"] =  supplier.IsInactive
        
        dicData["IsSameAsPhysicalAddress"] =  supplier.IsSameAsPhysicalAddress
        dicData["IsSameAsPostalAddress"] =  supplier.IsSameAsPostalAddress
        dicData["LastName"] =  supplier.LastName
        dicData["Memos"] =  supplier.Memos
        dicData["PaymentMemos"] =  supplier.PaymentMemos
        dicData["Phone"] =  supplier.Phone
        dicData["PhysicalAddress"] =  supplier.PhysicalAddress
        dicData["PhysicalAddressLine2"] =  supplier.PhysicalAddressLine2
        dicData["PhysicalCity"] =  supplier.PhysicalCity
        dicData["PhysicalCountry"] =  supplier.PhysicalCountry
        dicData["PhysicalState"] =  supplier.PhysicalState
         dicData["PhysicalPostalCode"] =  supplier.PhysicalPostalCode
        
        dicData["PostalAddress"] =  supplier.PostalAddress
        dicData["PostalAddressLine2"] =  supplier.PostalAddressLine2
        dicData["PostalCity"] =  supplier.PostalCity
        dicData["PostalCountry"] =  supplier.PostalCountry
        dicData["PostalState"] =  supplier.PostalState
        dicData["PostalPostalCode"] =  supplier.PostalPostalCode
        
        dicData["ShippingAddress"] =  supplier.ShippingAddress
        dicData["ShippingAddressLine2"] =  supplier.ShippingAddressLine2
        dicData["ShippingCity"] =  supplier.ShippingCity
        dicData["ShippingCountry"] =  supplier.ShippingCountry
        dicData["ShippingState"] =  supplier.ShippingState
         dicData["ShippingPostalCode"] =  supplier.ShippingPostalCode
        
        dicData["StatementText"] =  supplier.StatementText
        dicData["SupplierID"] =  supplier.SupplierID
        dicData["SupplierName"] =  supplier.SupplierName
        dicData["Title"] =  supplier.Title
        
        return dicData
    }
    
    func convertCustomerToArray() -> [String: AnyObject]
    {
        var dicData = [String: AnyObject]()
        
        dicData["ABN"] =  customer.ABN
        dicData["BankAccountName"] =  customer.BankAccountName
        
        dicData["BankAccountNumber"] =  customer.BankAccountNumber
        
        dicData["BSBNumber"] =  customer.BSBNumber
      //  dicData["CreateDate"] =  customer.CreateDate.description
        dicData["DefaultSalesAccountID"] =  customer.DefaultSalesAccountID
     dicData["DefaultSalesDiscount"] =  customer.DefaultSalesDiscount
        dicData["DefaultSalesTaxCodeID"] =  customer.DefaultSalesTaxCodeID
        dicData["Email"] =  customer.Email
        dicData["Fax"] =  customer.Fax
        dicData["FirstName"] =  customer.FirstName
        dicData["IsInactive"] =  customer.IsInactive
        
        dicData["IsSameAsPhysicalAddress"] =  customer.IsSameAsPhysicalAddress
        dicData["IsSameAsPostalAddress"] =  customer.IsSameAsPostalAddress
        dicData["LastName"] =  customer.LastName
        dicData["Memos"] =  customer.Memos
        dicData["PaymentMemos"] =  customer.PaymentMemos
        dicData["Phone"] =  customer.Phone
        dicData["PhysicalAddress"] =  customer.PhysicalAddress
        dicData["PhysicalAddressLine2"] =  customer.PhysicalAddressLine2
        dicData["PhysicalCity"] =  customer.PhysicalCity
        dicData["PhysicalCountry"] =  customer.PhysicalCountry
        dicData["PhysicalState"] =  customer.PhysicalState
        dicData["PhysicalPostalCode"] =  customer.PhysicalPostalCode
        
        dicData["PostalAddress"] =  customer.PostalAddress
        dicData["PostalAddressLine2"] =  customer.PostalAddressLine2
        dicData["PostalCity"] =  customer.PostalCity
        dicData["PostalCountry"] =  customer.PostalCountry
        dicData["PostalState"] =  customer.PostalState
        dicData["PostalPostalCode"] =  customer.PostalPostalCode
        
        dicData["ShippingAddress"] =  customer.ShippingAddress
        dicData["ShippingAddressLine2"] =  customer.ShippingAddressLine2
        dicData["ShippingCity"] =  customer.ShippingCity
        dicData["ShippingCountry"] =  customer.ShippingCountry
        dicData["ShippingState"] =  customer.ShippingState
        dicData["ShippingPostalCode"] =  customer.ShippingPostalCode
        
        dicData["StatementText"] =  customer.StatementText
        dicData["CustomerID"] =  customer.CustomerID
        dicData["CustomerName"] =  customer.CustomerName
        dicData["Title"] =  customer.Title
        
        return dicData
    }
    @IBAction func contactNameEditingChanged(sender: AnyObject) {
        
        let txtContactName = sender as! UITextField
        
        if ContactType == "Supplier"
        {
            
            supplier.SupplierName = txtContactName.text!
        }
        else {
            customer.CustomerName = txtContactName.text!
        }
    }
    @IBAction func phoneEditingChanged(sender: AnyObject) {
        let txtPhone = sender as! UITextField
        
        if CallButton != nil {
            if txtPhone.text?.length == 0 {
                CallButton?.enabled = false
            }
            else {
                CallButton?.enabled = true
            }
        }
        if ContactType == "Supplier"
        {
            
            supplier.Phone = txtPhone.text!
            
        }
        else{
            customer.Phone = txtPhone.text!
        }
        
    }
    
    @IBAction func emailEditingChanged(sender: AnyObject) {
        let txtEmail = sender as! UITextField
        
        if ContactType == "Supplier"
        {
            
            supplier.Email = txtEmail.text!
            
        }
        else {
            customer.Email = txtEmail.text!
        }
        
    }
    
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
      
        if ContactType == "Supplier"{
            supplier.Memos = Memo.text
    }
        else {
            customer.Memos = Memo.text
        }
    }
    @IBAction func CallButtonClick(sender: AnyObject) {
        
        if ContactType == "Supplier"
        {
            if let url = NSURL(string: "tel://\(supplier.Phone!)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        else {
            if let url = NSURL(string: "tel://\(customer.Phone!)") {
                UIApplication.sharedApplication().openURL(url)
            }
        }
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
