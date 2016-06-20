//
//  SendEmailViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 17/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SendEmailViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol ,UITextViewDelegate{
    
    var Message = UITextView()
    var originalRowsDic: [Int: String] = [0: "FromCell", 1: "ToCell",2: "SubjectCell",3: "MessageCell"]
    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var SendEmailTableView: UITableView!
    var salesTransactionHeader = SalesTransactionsHeader()
    var customer = Customer()
    
    var email = Email()
    var isPreLoad = false
  
    
    override func viewWillAppear(animated: Bool) {
        
        email.TransactionID = salesTransactionHeader.SalesTransactionsHeaderID
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        var attachedURL = "&CustomerID=" + salesTransactionHeader.CustomerID
        isPreLoad = true
        q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerByID", attachedURL: attachedURL)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
SendEmailTableView.delegate = self
        SendEmailTableView.dataSource = self
        setControlAppear()
       
        // Do any additional setup after loading the view.
    }
    func setControlAppear()
    {
        // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        
        SendEmailTableView.tableFooterView = UIView(frame: CGRectZero)
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
        //        if indexPath.row <= 8 {
        //       resuseIdentifier = originalRowsDic[indexPath.row]!
        //        }
        //        if indexPath.row > 8 {
        //             resuseIdentifier = originalRowsDic[5]!
        //        }
        
      
        
        resuseIdentifier = originalRowsDic[indexPath.row]!
        //        if indexPath.row <= 8 {
        //       resuseIdentifier = originalRowsDic[indexPath.row]!
        //        }
        //        if indexPath.row > 8 {
        //             resuseIdentifier = originalRowsDic[5]!
        //        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! SendEmailTableViewCell
        
        if resuseIdentifier == "FromCell" {
            
            var q6DBLib = Q6DBLib()
            var userInfos  = q6DBLib.getUserInfos() as [String:String]
            email.FromEmail = userInfos["LoginEmail"]!
            email.SenderName = userInfos["LoginFirstName"]! + " " + userInfos["LoginLastName"]!
            
            cell.txtFrom.text = email.FromEmail
            //  cell.lblContactName.text = "Supplier Name"
        }
        
        if resuseIdentifier == "ToCell" {
            
           cell.txtTo.text = email.ToEmail
        }
        if resuseIdentifier == "SubjectCell" {
            
            email.SubjectName =  salesTransactionHeader.SalesType + " " + salesTransactionHeader.ReferenceNo
            
            cell.txtSubject.text = email.SubjectName
        }
        
        if resuseIdentifier == "MessageCell" {
            
            Message = cell.txtMessage
           Message.delegate = self
            
      
            //  cell.lblContactName.text = "Supplier Name"
        }
        
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
    @IBAction func FromEditingChanged(sender: AnyObject) {
        var txtFrom = sender as! UITextField
        email.FromEmail = txtFrom.text!
    }
    @IBAction func ToEditingChanged(sender: AnyObject) {
        
        var txtTo = sender as! UITextField
        email.ToEmail = txtTo.text!
    }
    @IBAction func SubjectEditingChanged(sender: AnyObject) {
        var txtSubject = sender as! UITextField
        email.SubjectName = txtSubject.text!
    }
    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        
      email.BodyMessage = textView.text
    }
    
    @IBAction func SendButtonClicked(sender: AnyObject) {
        
        if email.FromEmail.length == 0  {
           Q6CommonLib.q6UIAlertPopupController("Information Message", message: "From Email can not be empty", viewController: self, timeArrange: 2)
        }
        else if email.ToEmail.length == 0 {
          Q6CommonLib.q6UIAlertPopupController("Information Message", message: "To Email can not be empty", viewController: self, timeArrange: 2)
        }
        else if email.SubjectName.length == 0 {
           
            Q6CommonLib.q6UIAlertPopupController("Information Message", message: "Subject Name can not be empty", viewController: self, timeArrange: 2)
            
        }
        else {
            
            var dicData=[String:AnyObject]()
            
            
            var q6DBLib = Q6DBLib()
            let q6CommonLib = Q6CommonLib(myObject: self)
            var userInfos = q6DBLib.getUserInfos()
            
            var LoginDetail = InternalUserLoginParameter()
            
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
            
            dicData["TransactionID"] = email.TransactionID
            dicData["SenderName"] = email.SenderName
            dicData["FromEmail"] = email.FromEmail
            dicData["ToEmail"] = email.ToEmail
            dicData["CcEmail"] = email.CcEmail
            dicData["BccEmail"] = email.BccEmail
            dicData["BodyMessage"] = email.BodyMessage
            dicData["ModuleName"] = email.ModuleName
            dicData["SubjectName"] = email.SubjectName
            dicData["SendMeACopy"] = email.SendMeACopy
        
            isPreLoad = false
             q6CommonLib.Q6IosClientPostAPI("Email",ActionName: "SendEmail", dicData:dicData)
            
        }
    }
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        
        var postDicData :[String:AnyObject]
      
        if isPreLoad == true
        {
        do {
            
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["Customer"] as! [String : AnyObject]
            print("returnDate Count" + returnData.count.description)
            //                for i in 0  ..< returnData.count {
            var dataItem = returnData  //[i]
            email.ToEmail = dataItem["Email"] as! String
            
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.SendEmailTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
            }
       
        }
        catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }
        }
        else if isPreLoad == false {
            
            do {
                
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                var IsSuccessed = postDicData["IsSuccessed"] as! Bool
                
                if IsSuccessed == true {
                   
                    
                    let alert = UIAlertController(title: "Information message", message: "Send  Successfully!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
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
                        self.navigationController!.popViewControllerAnimated(true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }

                    
                }
                else {
                 
                    let alert = UIAlertController(title: "Information message", message: "Send Fail!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                    
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                                                  Int64(3 * Double(NSEC_PER_SEC)))
           
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.dismissViewControllerAnimated(true, completion: nil);
                        
                        // self.navigationController!.popViewControllerAnimated(true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }
            }
            catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
                
        }
        
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
