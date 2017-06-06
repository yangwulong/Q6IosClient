//
//  ContactViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 15/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol ,UITextViewDelegate, DropDownmenuDelegate {
    var originalRowsDic: [Int: String] = [0: "ContactNameCell", 1: "PhoneCell",2: "EmailCell", 3: "DueDateCell", 4: "MemoCell"]
    
    @IBOutlet weak var btnSaveButton: UIBarButtonItem!
    @IBOutlet weak var btnCancelButton: UIBarButtonItem!
    var Memo = UITextView()
    var OperationType = String()
    var ContactType = String()
    var ContactID:String?
    var isPreLoad = false
    var supplier = Supplier()
    var customer = Customer()
    var CallButton:UIButton?
    
    private var dueDateBtn: UIButton?
    private var dropmenu: DropDownmenu?
    private var isDropmenuShow = false
    private let dueDates = [ofTheFollowingMonth, daysAfterTheInvoiceDate, daysAfterTheEndOfTheInvoiceMonth, ofTheCurrentMonth]
    private var dueDateType: Int = 0
    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var ContactTableView: UITableView!
    private var contactCell: ContactViewTableViewCell?
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    weak var delegate2: Q6GoBackFromViewTwo?
    
    override func viewWillAppear(_ animated: Bool) {
        
        Q6ActivityIndicatorView.hidesWhenStopped = true
        Q6ActivityIndicatorView.stopAnimating()
        if ContactType == "Supplier" {
            
            navigationBar.topItem?.title = "Supplier"
            
        } else {
            
             navigationBar.topItem?.title = "Customer"
        }
        if OperationType == "Edit" {
            
            if ContactType == "Supplier" {
                
                Q6ActivityIndicatorView.startAnimating()
                let q6CommonLib = Q6CommonLib(myObject: self)
                
                let attachedURL = "&SupplierID=" + ContactID!
                isPreLoad = true
                q6CommonLib.Q6IosClientGetApi(ModelName: "Purchase", ActionName: "GetSupplierByID", attachedURL: attachedURL)
            }
            
            if ContactType == "Customer" {
                
                Q6ActivityIndicatorView.startAnimating()
                let q6CommonLib = Q6CommonLib(myObject: self)
                
                let attachedURL = "&CustomerID=" + ContactID!
                isPreLoad = true
                q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetCustomerByID", attachedURL: attachedURL)
                
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
    
    func setControlAppear() {
        // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        // lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        
        ContactTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: Table view data source
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // print("addItemsDic" + addItemsDic.count.description)
        // return originalRowsDic.count + addItemsDic.count
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let resuseIdentifier = originalRowsDic[indexPath.row]!
        //        if indexPath.row <= 8 {
        //       resuseIdentifier = originalRowsDic[indexPath.row]!
        //        }
        //        if indexPath.row > 8 {
        //             resuseIdentifier = originalRowsDic[5]!
        //        }
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as! ContactViewTableViewCell
        
        if resuseIdentifier == "ContactNameCell" {
            if ContactType == "Supplier"
            {
                cell.txtContactName.text = supplier.SupplierName
            }
            else {
                cell.txtContactName.text = customer.CustomerName
            }
        }
        
        if resuseIdentifier == "PhoneCell" {
            
            CallButton = cell.btnCallButton
            
            if ContactType == "Supplier"{
                cell.txtPhone.text = supplier.Phone
                print("phone: \(String(describing: supplier.Phone))")
                if supplier.Phone?.length == 0 {
                    CallButton?.isEnabled = false
                }
                else {
                    CallButton?.isEnabled = true
                }
            }
            
            if ContactType == "Customer"{
                cell.txtPhone.text = customer.Phone
                if customer.Phone?.length == 0 {
                    CallButton?.isEnabled = false
                }
                else {
                    CallButton?.isEnabled = true
                }
            }
            
            //  cell.lblContactName.text = "Supplier Name"
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
        
        if resuseIdentifier == "DueDateCell" {
            
            contactCell = cell
            
            cell.btnDueDate.layer.masksToBounds = true
            cell.btnDueDate.layer.cornerRadius = 5
            cell.btnDueDate.layer.borderWidth = 0.5
            cell.btnDueDate.layer.borderColor = UIColor(red: 193 / 255.0, green: 194 / 255.0, blue: 194 / 255.0, alpha: 1).cgColor
            cell.btnDueDate.titleLabel?.adjustsFontSizeToFitWidth = true
            cell.btnDueDate.titleLabel?.numberOfLines = 0
            
            cell.btnDueDate.addTarget(self, action: #selector(btnDueDateAction(btn:)), for: .touchUpInside)
            
            if ContactType == "Supplier" {
                
                if supplier.DefaultDueDate == 0 {
                    
                    cell.txtDueDate.text = ""
                }else {
                    
                    cell.txtDueDate.text = NSNumber(value: supplier.DefaultDueDate).stringValue
                }
                
                if supplier.DefaultDueDateOption == DueDateType.ofTheFollowingMonth.rawValue {
                    
                    cell.btnDueDate.setTitle(ofTheCurrentMonth, for: .normal)
                    
                }else if supplier.DefaultDueDateOption == DueDateType.daysAfterTheInvoiceDate.rawValue {
                    
                    cell.btnDueDate.setTitle(daysAfterTheInvoiceDate, for: .normal)
                    
                }else if supplier.DefaultDueDateOption == DueDateType.daysAfterTheEndOfTheInvoiceMonth.rawValue {
                    
                    cell.btnDueDate.setTitle(daysAfterTheEndOfTheInvoiceMonth, for: .normal)
                    
                }else if supplier.DefaultDueDateOption == DueDateType.ofTheCurrentMonth.rawValue {
                    
                    cell.btnDueDate.setTitle(ofTheCurrentMonth, for: .normal)
                }
            }else {
                
                if customer.DefaultDueDate == 0 {
                    
                    cell.txtDueDate.text = ""
                }else {
                    
                    cell.txtDueDate.text = NSNumber(value: customer.DefaultDueDate).stringValue
                }
                
                if customer.DefaultDueDateOption == DueDateType.ofTheFollowingMonth.rawValue {
                    
                    cell.btnDueDate.setTitle(ofTheCurrentMonth, for: .normal)
                    
                }else if customer.DefaultDueDateOption == DueDateType.daysAfterTheInvoiceDate.rawValue {
                    
                    cell.btnDueDate.setTitle(daysAfterTheInvoiceDate, for: .normal)
                    
                }else if customer.DefaultDueDateOption == DueDateType.daysAfterTheEndOfTheInvoiceMonth.rawValue {
                    
                    cell.btnDueDate.setTitle(daysAfterTheEndOfTheInvoiceMonth, for: .normal)
                    
                }else if customer.DefaultDueDateOption == DueDateType.ofTheCurrentMonth.rawValue {
                    
                    cell.btnDueDate.setTitle(ofTheCurrentMonth, for: .normal)
                }
            }
        }
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isDropmenuShow {
            
            if indexPath.row == 3 {
                
                let totalH = dueDates.count * 35
                let height: CGFloat = CGFloat(totalH > 150 ? 150 : totalH)
                return height + 35
                
            } else if indexPath.row == 4 {
                let screenHeight = UIScreen.main.bounds.height
                return screenHeight - 4*40 - 64 - 49
                
            } else {
                return 40
            }
            
        }else {
            
            if indexPath.row == 4 {
                let screenHeight = UIScreen.main.bounds.height
                return screenHeight - 4*40 - 64 - 49
            } else {
                return 40
            }
        }
    }
    
    @objc private func btnDueDateAction(btn: UIButton) {
        
        if dropmenu == nil {
            let totalH = dueDates.count * 35
            let height: CGFloat = CGFloat(totalH > 150 ? 150 : totalH)
            dropmenu = DropDownmenu(viewS: btn, height: height, array: dueDates, direction: .down)
            dropmenu?.delegate = self
            isDropmenuShow = true
            ContactTableView.reloadData()
        }else {
            
            isDropmenuShow = false
            ContactTableView.reloadData()
            dropmenu?.hideDropDownmenu(viewS: btn)
            emptyDropmenu()
        }
    }
    
    // MARK: Dropmenu delegate
    func dropDownmenuSelected(text: String) {
        
        isDropmenuShow = false
        ContactTableView.reloadData()
        contactCell?.btnDueDate.setTitle(text, for: .normal)
        emptyDropmenu()
        
        if text == ofTheFollowingMonth {
            
            dueDateType = DueDateType.ofTheFollowingMonth.rawValue
            
        }else if text == daysAfterTheInvoiceDate {
            
            dueDateType = DueDateType.daysAfterTheInvoiceDate.rawValue
            
        }else if text == daysAfterTheEndOfTheInvoiceMonth {
            
            dueDateType = DueDateType.daysAfterTheEndOfTheInvoiceMonth.rawValue
            
        }else if text ==  ofTheCurrentMonth {
            
            dueDateType = DueDateType.ofTheCurrentMonth.rawValue
        }
        
        if let cell = contactCell {
            
            dueDateEditing(textField: cell.txtDueDate)
        }
    }
    
    private func emptyDropmenu() {
        
        dropmenu = nil
    }
    
    // MARK: data load
    
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject {
        
        if isPreLoad == true && OperationType == "Edit" && ContactType == "Supplier" {
            
            var postDicData :[String:AnyObject]
            
            do {
            
                postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
                
                print("postDicData: \(postDicData)")
                
                let returnData = postDicData["Supplier"] as! [String : AnyObject]
                print("returnDate Count" + returnData.count.description)
//              for i in 0  ..< returnData.count {
                var dataItem = returnData  //[i]
                supplier.ABN = dataItem["ABN"] as? String
                supplier.BankAccountName = dataItem["BankAccountName"] as? String
                supplier.BankAccountNumber = dataItem["BankAccountNumber"] as? String
                supplier.BSBNumber = dataItem["BSBNumber"] as? String
            
                
                let CreateDate = dataItem["CreateDate"] as? String
//              var convertDueDate:NSDate?
//              if dueDate != nil {
//              print("dueDate sss" + dueDate!)
//
//              convertDueDate = dueDate?.toDateTime()
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
                
                if let defaultDueDate = dataItem["DefaultDueDate"], let defaultDueDateOption = dataItem["DefaultDueDateOption"] {
                    
                    supplier.DefaultDueDateOption = (defaultDueDateOption as? Int) ?? 0
                    supplier.DefaultDueDate = (defaultDueDate as? Int) ?? 0
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
                
                DispatchQueue.main.async {
                    self.ContactTableView.reloadData()
                    self.Q6ActivityIndicatorView.hidesWhenStopped = true
                    self.Q6ActivityIndicatorView.stopAnimating()
            
                }
                
            }
            catch  {
                print("error parsing response from POST on /posts")
                
                return "" as AnyObject
            }
        } else if isPreLoad == true && OperationType == "Edit" && ContactType == "Customer" {
            
            
            var postDicData :[String:AnyObject]
            
            do {
                
                postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
                
                let returnData = postDicData["Customer"] as! [String : AnyObject]
                print("returnDate Count" + returnData.count.description)
                //                for i in 0  ..< returnData.count {
                var dataItem = returnData  //[i]
                customer.ABN = dataItem["ABN"] as? String
                customer.BankAccountName = dataItem["BankAccountName"] as? String
                customer.BankAccountNumber = dataItem["BankAccountNumber"] as? String
                customer.BSBNumber = dataItem["BSBNumber"] as? String
                
                
                let CreateDate = dataItem["CreateDate"] as? String
                //                var convertDueDate:NSDate?
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
                
                if let defaultDueDate = dataItem["DefaultDueDate"], let defaultDueDateOption = dataItem["DefaultDueDateOption"] {
                    
                    customer.DefaultDueDateOption = (defaultDueDateOption as? Int) ?? 0
                    customer.DefaultDueDate = (defaultDueDate as? Int) ?? 0
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
                
                DispatchQueue.main.async {
              
                    self.ContactTableView.reloadData()
                    self.Q6ActivityIndicatorView.hidesWhenStopped = true
                    self.Q6ActivityIndicatorView.stopAnimating()
                }
                
            }
            catch  {
                print("error parsing response from POST on /posts")
                
                return "" as AnyObject
            }
            
        } else if isPreLoad == false   {
            
        var postDicData :[String:AnyObject]
        var _ : Bool
        do {
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
            
            let IsSuccessed = postDicData["IsSuccessed"] as! Bool
            
            if IsSuccessed == true {
                
               DispatchQueue.main.async {
                    
                    // let all subview control resignfirstresponse()
                    self.view.endEditing(true)
                
                }
                
                _ = navigationController
                // Q6CommonLib.q6UIAlertPopupControllerThenGoBack("Information message", message: "Save Successfully!", viewController: self,timeArrange:3,navigationController: nav!)
                                
                let alert = UIAlertController(title: "Information message", message: "Save Successfully!", preferredStyle: UIAlertControllerStyle.alert)
                
                DispatchQueue.main.async {
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
//                let when = DispatchTime.now() + seconds
//                DispatchQueue.main.asyncAfter(deadline: when){
//                    // Your code with delay
//                }
//                DispatchQueue.main.asyncAfter(deadline: <#T##DispatchTime#>, execute: <#T##DispatchWorkItem#>)
                let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                
                let delayTime2 = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                
//                let delayTime = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),
//                                              Int64(3 * Double(NSEC_PER_SEC)))
//                let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
//                                               Int64(4 * Double(NSEC_PER_SEC)))
                
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    self.dismiss(animated: true, completion: nil);
                    
                    // self.navigationController!.popViewControllerAnimated(true)
                    // self.navigationController?.popToRootViewControllerAnimated(true)
                }
                DispatchQueue.main.asyncAfter(deadline: delayTime2) { // self.dismissViewControllerAnimated(true, completion: nil);
                            self.delegate2?.sendGoBackContactDetailView(fromView: "ContactViewController", fromButton: "Save")
                            self.navigationController!.popViewController(animated: true)
                            // self.navigationController?.popToRootViewControllerAnimated(true)
                }
                
            }else {
                
                let alert = UIAlertController(title: "Information message", message: "Save Fail: \(String(describing: postDicData["Message"]!))", preferredStyle: UIAlertControllerStyle.alert)
                
                DispatchQueue.main.async {
                    
                    self.present(alert, animated: true, completion: nil)
                    self.btnSaveButton.isEnabled = true
                    self.btnCancelButton.isEnabled = true
                    
                    
                    let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    let delayTime2 = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        self.dismiss(animated: true, completion: nil);
                        
                        // self.navigationController!.popViewControllerAnimated(true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    DispatchQueue.main.asyncAfter(deadline: delayTime2) { // self.dismissViewControllerAnimated(true, completion: nil);
                        self.delegate2?.sendGoBackContactDetailView(fromView: "ContactViewController", fromButton: "Save")
                        self.navigationController!.popViewController(animated: true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }
            }
        } catch  {
            print("error parsing response from POST on /posts")
            btnSaveButton.isEnabled = true
            btnCancelButton.isEnabled = true
            return "" as AnyObject
        }
        
        }
        return "" as AnyObject
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
        
        LoginDetailDicData["Email"] = userInfos["LoginEmail"]! as AnyObject?
        LoginDetailDicData["Password"] = userInfos["PassWord"]! as AnyObject?
        LoginDetailDicData["CompanyID"] = userInfos["CompanyID"]! as AnyObject?
        LoginDetailDicData["WebApiTOKEN"] = Q6CommonLib.getQ6WebAPIToken() as AnyObject?
        
        dicData["LoginDetail"] = LoginDetailDicData as AnyObject?
        dicData["NeedValidate"] = false as AnyObject?
        
        if ContactType == "Supplier" {
            
            if supplier.SupplierName.length == 0 {
                
                Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message:" Supplier Name can not be empty!", viewController: self)
                
            } else if (supplier.Email?.length)!>0 &&  Q6CommonLib.isEmailAddressValid(email: supplier.Email!) == false {
                
                Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message:" Email Address is not valid !", viewController: self)
                
            } else {
                
                dicData["Supplier"] = convertSupplierToArray() as AnyObject?
                    
                if OperationType == "Create" {
                    
                    q6CommonLib.Q6IosClientPostAPI(ModeName: "Purchase",ActionName: "AddSupplier", dicData:dicData)
                    print("dicData: \(dicData)")
                } else if OperationType == "Edit" {
                    
                    q6CommonLib.Q6IosClientPostAPI(ModeName: "Purchase",ActionName: "EditSupplier", dicData:dicData)
                }
                    
                    btnSaveButton.isEnabled = false
                    btnCancelButton.isEnabled = false
            }
        }
        
        if ContactType == "Customer" {
            
            if customer.CustomerName.length == 0 {
                
                Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message:" Customer Name can not be empty!", viewController: self)
                
            } else if (customer.Email?.length)!>0 &&  Q6CommonLib.isEmailAddressValid(email: customer.Email!) == false {
                
                Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message:" Email Address is not valid !", viewController: self)
                
            } else {
                dicData["Customer"] = convertCustomerToArray() as AnyObject?
                
                if OperationType == "Create" {
                    
                    q6CommonLib.Q6IosClientPostAPI(ModeName: "Sale",ActionName: "AddCustomer", dicData:dicData)
                }
                else if OperationType == "Edit" {
                    
                    q6CommonLib.Q6IosClientPostAPI(ModeName: "Sale",ActionName: "EditCustomer", dicData:dicData)
                }
                btnSaveButton.isEnabled = false
                btnCancelButton.isEnabled = false
            }
        }
       
    }

    @IBAction func CancelButtonClick(sender: AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func convertSupplierToArray() -> [String: AnyObject] {
        var dicData = [String: AnyObject]()
        
        dicData["ABN"] =  supplier.ABN as AnyObject?
        dicData["BankAccountName"] =  supplier.BankAccountName as AnyObject?
        
        dicData["BankAccountNumber"] =  supplier.BankAccountNumber as AnyObject?
        
        dicData["BSBNumber"] =  supplier.BSBNumber as AnyObject?
        dicData["CreateDate"] =  supplier.CreateDate.description as AnyObject?
        dicData["DefaultPurchasesAccountID"] =  supplier.DefaultPurchasesAccountID as AnyObject?
       // dicData["DefaultPurchasesAccountNameWithAccountNo"] =  supplier.DefaultPurchasesAccountNameWithAccountNo
        dicData["DefaultPurchasesTaxCodeID"] =  supplier.DefaultPurchasesTaxCodeID as AnyObject?
        
        if supplier.DefaultDueDate > 0 {
            
            dicData["DefaultDueDateOption"] = supplier.DefaultDueDateOption as AnyObject
            dicData["DefaultDueDate"] = supplier.DefaultDueDate as AnyObject
            
        }else {
            
            dicData["DefaultDueDateOption"] = "" as AnyObject
            dicData["DefaultDueDate"] = "" as AnyObject
        }
        
        dicData["Email"] =  supplier.Email as AnyObject?
        dicData["Fax"] =  supplier.Fax as AnyObject?
        dicData["FirstName"] =  supplier.FirstName as AnyObject?
        dicData["IsInactive"] =  supplier.IsInactive as AnyObject?
        
        dicData["IsSameAsPhysicalAddress"] =  supplier.IsSameAsPhysicalAddress as AnyObject?
        dicData["IsSameAsPostalAddress"] =  supplier.IsSameAsPostalAddress as AnyObject?
        dicData["LastName"] =  supplier.LastName as AnyObject?
        dicData["Memos"] =  supplier.Memos as AnyObject?
        dicData["PaymentMemos"] =  supplier.PaymentMemos as AnyObject?
        dicData["Phone"] =  supplier.Phone as AnyObject?
        dicData["PhysicalAddress"] =  supplier.PhysicalAddress as AnyObject?
        dicData["PhysicalAddressLine2"] =  supplier.PhysicalAddressLine2 as AnyObject?
        dicData["PhysicalCity"] =  supplier.PhysicalCity as AnyObject?
        dicData["PhysicalCountry"] =  supplier.PhysicalCountry as AnyObject?
        dicData["PhysicalState"] =  supplier.PhysicalState as AnyObject?
         dicData["PhysicalPostalCode"] =  supplier.PhysicalPostalCode as AnyObject?
        
        dicData["PostalAddress"] =  supplier.PostalAddress as AnyObject?
        dicData["PostalAddressLine2"] =  supplier.PostalAddressLine2 as AnyObject?
        dicData["PostalCity"] =  supplier.PostalCity as AnyObject?
        dicData["PostalCountry"] =  supplier.PostalCountry as AnyObject?
        dicData["PostalState"] =  supplier.PostalState as AnyObject?
        dicData["PostalPostalCode"] =  supplier.PostalPostalCode as AnyObject?
        
        dicData["ShippingAddress"] =  supplier.ShippingAddress as AnyObject?
        dicData["ShippingAddressLine2"] =  supplier.ShippingAddressLine2 as AnyObject?
        dicData["ShippingCity"] =  supplier.ShippingCity as AnyObject?
        dicData["ShippingCountry"] =  supplier.ShippingCountry as AnyObject?
        dicData["ShippingState"] =  supplier.ShippingState as AnyObject?
        dicData["ShippingPostalCode"] =  supplier.ShippingPostalCode as AnyObject?
        
        dicData["StatementText"] =  supplier.StatementText as AnyObject?
        dicData["SupplierID"] =  supplier.SupplierID as AnyObject?
        dicData["SupplierName"] =  supplier.SupplierName as AnyObject?
        dicData["Title"] =  supplier.Title as AnyObject?
        
        return dicData
    }
    
    func convertCustomerToArray() -> [String: AnyObject]
    {
        var dicData = [String: AnyObject]()
        
        dicData["ABN"] =  customer.ABN as AnyObject?
        dicData["BankAccountName"] =  customer.BankAccountName as AnyObject?
        
        dicData["BankAccountNumber"] =  customer.BankAccountNumber as AnyObject?
        
        dicData["BSBNumber"] =  customer.BSBNumber as AnyObject?
        //  dicData["CreateDate"] =  customer.CreateDate.description
        dicData["DefaultSalesAccountID"] =  customer.DefaultSalesAccountID as AnyObject?
        dicData["DefaultSalesDiscount"] =  customer.DefaultSalesDiscount as AnyObject?
        dicData["DefaultSalesTaxCodeID"] =  customer.DefaultSalesTaxCodeID as AnyObject?
        
        if customer.DefaultDueDate > 0 {
            
            dicData["DefaultDueDateOption"] = customer.DefaultDueDateOption as AnyObject
            dicData["DefaultDueDate"] = customer.DefaultDueDate as AnyObject
            
        }else {
            
            dicData["DefaultDueDateOption"] = "" as AnyObject
            dicData["DefaultDueDate"] = "" as AnyObject
        }
        
        dicData["Email"] =  customer.Email as AnyObject?
        dicData["Fax"] =  customer.Fax as AnyObject?
        dicData["FirstName"] =  customer.FirstName as AnyObject?
        dicData["IsInactive"] =  customer.IsInactive as AnyObject?
        
        dicData["IsSameAsPhysicalAddress"] =  customer.IsSameAsPhysicalAddress as AnyObject?
        dicData["IsSameAsPostalAddress"] =  customer.IsSameAsPostalAddress as AnyObject?
        dicData["LastName"] =  customer.LastName as AnyObject?
        dicData["Memos"] =  customer.Memos as AnyObject?
        dicData["PaymentMemos"] =  customer.PaymentMemos as AnyObject?
        dicData["Phone"] =  customer.Phone as AnyObject?
        dicData["PhysicalAddress"] =  customer.PhysicalAddress as AnyObject?
        dicData["PhysicalAddressLine2"] =  customer.PhysicalAddressLine2 as AnyObject?
        dicData["PhysicalCity"] =  customer.PhysicalCity as AnyObject?
        dicData["PhysicalCountry"] =  customer.PhysicalCountry as AnyObject?
        dicData["PhysicalState"] =  customer.PhysicalState as AnyObject?
        dicData["PhysicalPostalCode"] =  customer.PhysicalPostalCode as AnyObject?
        
        dicData["PostalAddress"] =  customer.PostalAddress as AnyObject?
        dicData["PostalAddressLine2"] =  customer.PostalAddressLine2 as AnyObject?
        dicData["PostalCity"] =  customer.PostalCity as AnyObject?
        dicData["PostalCountry"] =  customer.PostalCountry as AnyObject?
        dicData["PostalState"] =  customer.PostalState as AnyObject?
        dicData["PostalPostalCode"] =  customer.PostalPostalCode as AnyObject?
        
        dicData["ShippingAddress"] =  customer.ShippingAddress as AnyObject?
        dicData["ShippingAddressLine2"] =  customer.ShippingAddressLine2 as AnyObject?
        dicData["ShippingCity"] =  customer.ShippingCity as AnyObject?
        dicData["ShippingCountry"] =  customer.ShippingCountry as AnyObject?
        dicData["ShippingState"] =  customer.ShippingState as AnyObject?
        dicData["ShippingPostalCode"] =  customer.ShippingPostalCode as AnyObject?
        
        dicData["StatementText"] =  customer.StatementText as AnyObject?
        dicData["CustomerID"] =  customer.CustomerID as AnyObject?
        dicData["CustomerName"] =  customer.CustomerName as AnyObject?
        dicData["Title"] =  customer.Title as AnyObject?
        
        return dicData
    }
    
    // MARK: UITextFieldDelegate
    
    @IBAction func contactNameEditingChanged(_ sender: AnyObject) {
 
        let txtContactName = sender as! UITextField
        
        if ContactType == "Supplier"
        {
            
            supplier.SupplierName = txtContactName.text!
        }
        else {
            customer.CustomerName = txtContactName.text!
        }
    }
    
    @IBAction func phoneEditingChanged(_ sender: AnyObject) {

        let txtPhone = sender as! UITextField
        
        if CallButton != nil {
            if txtPhone.text?.length == 0 {
                CallButton?.isEnabled = false
            }
            else {
                CallButton?.isEnabled = true
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
    
    @IBAction func dueDateEditingBegin(_ sender: UITextField) {
        
//        let dueDateOptionBtnTitle = contactCell?.btnDueDate.title(for: .normal)
//        
//        if dueDateOptionBtnTitle == nil || dueDateOptionBtnTitle == "" {
//            
//            Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message:" Please enter the default date date option !", viewController: self)
//            
//        }
    }
    
    @IBAction func dueDateEditingEnd(_ sender: UITextField) {
        
        dueDateEditing(textField: sender)
    }
    
    private func dueDateEditing(textField: UITextField) {
        
        let defaultDueDate = NSString(string: textField.text ?? "").integerValue
        
        if ContactType == "Supplier" {
            
            supplier.DefaultDueDateOption = dueDateType
            supplier.DefaultDueDate = defaultDueDate
            
        }else {
            
            customer.DefaultDueDateOption = dueDateType
            customer.DefaultDueDate = defaultDueDate
        }
        
        if dueDateType == DueDateType.ofTheCurrentMonth.rawValue || dueDateType == DueDateType.ofTheFollowingMonth.rawValue {
            
            if defaultDueDate < 1 || defaultDueDate > 31 {
                
                Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "You can only input number between 1 and 31 when you choose  of the following(current) month!", viewController: self)
            }
        }
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
      
        if ContactType == "Supplier"{
            supplier.Memos = Memo.text
        } else {
            customer.Memos = Memo.text
        }
    }
    
    @IBAction func CallButtonClick(sender: AnyObject) {
        
        if ContactType == "Supplier"
        {
            if let url = NSURL(string: "tel://\(supplier.Phone!)") {
                UIApplication.shared.openURL(url as URL)
            }
        }
        else {
            if let url = NSURL(string: "tel://\(customer.Phone!)") {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
    
    // MARK: Temporarily not used, to avoid being given
    
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

}
