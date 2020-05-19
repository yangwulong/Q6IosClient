//
//  SendEmailViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 17/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SendEmailViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol ,UITextViewDelegate{
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var btnSendEmail: UIBarButtonItem!
    var Message = UITextView()
    var originalRowsDic: [Int: String] = [0: "FromCell", 1: "ToCell",2: "SubjectCell",3: "MessageCell"]
    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var SendEmailTableView: UITableView!
    var salesTransactionHeader = SalesTransactionsHeader()
    var customer = Customer()
    
    var email = Email()
    var isPreLoad = false
  
    
    override func viewWillAppear(_ animated: Bool) {
        
        email.TransactionID = salesTransactionHeader.SalesTransactionsHeaderID
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        let attachedURL = "&CustomerID=" + salesTransactionHeader.CustomerID
        
        print("CustomerID " + salesTransactionHeader.CustomerID)
        isPreLoad = true
        q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetCustomerByID", attachedURL: attachedURL)
        
        
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
        
        SendEmailTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // print("addItemsDic" + addItemsDic.count.description)
        // return originalRowsDic.count + addItemsDic.count
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as! SendEmailTableViewCell
        
        if resuseIdentifier == "FromCell" {
            
            let q6DBLib = Q6DBLib()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3{
            let screenSize: CGRect = UIScreen.main.bounds
            let screenHeight = screenSize.height
            return screenHeight - 3*40
        }
        else {
            return 40
        }
    }
    @IBAction func FromEditingChanged(_ sender: AnyObject) {

        let txtFrom = sender as! UITextField
        email.FromEmail = txtFrom.text!
    }
    @IBAction func ToEditingChanged(_ sender: AnyObject) {
 
        
        let txtTo = sender as! UITextField
        email.ToEmail = txtTo.text!
    }
    @IBAction func SubjectEditingChanged(_ sender: AnyObject) {
   
        let txtSubject = sender as! UITextField
        email.SubjectName = txtSubject.text!
    }
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        
      email.BodyMessage = textView.text
    }
    
    @IBAction func SendButtonClicked(sender: AnyObject) {
        
        if email.FromEmail.length == 0  {
           Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "From Email can not be empty", viewController: self, timeArrange: 2)
        }
        else if email.ToEmail.length == 0 {
          Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "To Email can not be empty", viewController: self, timeArrange: 2)
        }
        else if email.SubjectName.length == 0 {
           
            Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "Subject Name can not be empty", viewController: self, timeArrange: 2)
            
        }
        else {
            
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
            
            dicData["TransactionID"] = email.TransactionID as AnyObject?
            dicData["SenderName"] = email.SenderName as AnyObject?
            dicData["FromEmail"] = email.FromEmail as AnyObject?
            dicData["ToEmail"] = email.ToEmail as AnyObject?
            dicData["CcEmail"] = email.CcEmail as AnyObject?
            dicData["BccEmail"] = email.BccEmail as AnyObject?
            dicData["BodyMessage"] = email.BodyMessage as AnyObject?
            dicData["ModuleName"] = email.ModuleName as AnyObject?
            dicData["SubjectName"] = email.SubjectName as AnyObject?
            dicData["SendMeACopy"] = email.SendMeACopy as AnyObject?
        
            isPreLoad = false
             q6CommonLib.Q6IosClientPostAPI(ModeName: "Email",ActionName: "SendEmail", dicData:dicData)
            
            btnSendEmail.isEnabled = false
            btnCancel.isEnabled = false
            
        }
    }
    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        
        var postDicData :[String:AnyObject]
      
        if isPreLoad == true
        {
        do {
            
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
            
            let returnData = postDicData["Customer"] as! [String : AnyObject]
            print("returnDate Count" + returnData.count.description)
            //                for i in 0  ..< returnData.count {
            var dataItem = returnData  //[i]
            email.ToEmail = dataItem["Email"] as! String
            
            
           DispatchQueue.main.async {
                
                self.SendEmailTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
            }
       
        }
        catch  {
            print("error parsing response from POST on /posts")
            
            return "" as AnyObject
        }
        }
        else if isPreLoad == false {
            
            do {
                
                postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
                
                let IsSuccessed = postDicData["IsSuccessed"] as! Bool
                
                if IsSuccessed == true {
                   
                    
                    let alert = UIAlertController(title: "Information message", message: "Send  Successfully!", preferredStyle: UIAlertController.Style.alert)
                    
                    
                   DispatchQueue.main.async {
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
//                    let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//                                                  Int64(3 * Double(NSEC_PER_SEC)))
//                    let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
//                                                   Int64(4 * Double(NSEC_PER_SEC)))
//                    dispatch_after(delayTime, dispatch_get_main_queue()) {
//                        self.dismissViewControllerAnimated(true, completion: nil);
//                        
//                        // self.navigationController!.popViewControllerAnimated(true)
//                        // self.navigationController?.popToRootViewControllerAnimated(true)
//                    }
//                    dispatch_after(delayTime2, dispatch_get_main_queue()) {
//                        // self.dismissViewControllerAnimated(true, completion: nil);
//                        self.navigationController!.popViewControllerAnimated(true)
//                        // self.navigationController?.popToRootViewControllerAnimated(true)
//                    }
                    
                    
                    
                    let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    let delayTime2 = DispatchTime.now() + Double(Int64(4 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    
                    //                let delayTime = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),
                    //                                              Int64(3 * Double(NSEC_PER_SEC)))
                    //                let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
                    //                                               Int64(4 * Double(NSEC_PER_SEC)))
                    
                    DispatchQueue.main.asyncAfter(deadline: delayTime)
                    {
                       self.dismiss(animated: true, completion: nil);
                        
                        // self.navigationController!.popViewControllerAnimated(true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    DispatchQueue.main.asyncAfter(deadline: delayTime2)
                    { // self.dismissViewControllerAnimated(true, completion: nil);
                   self.navigationController!.popViewController(animated: true)
                    }

                    
                }
                else {
                 
                    let alert = UIAlertController(title: "Information message", message: "Send Fail!", preferredStyle: UIAlertController.Style.alert)
                    
                    
                  DispatchQueue.main.async {
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                 let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
           
                            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        self.dismiss(animated: true, completion: nil);
                        
                        self.btnSendEmail.isEnabled = true
                        self.btnCancel.isEnabled = true
                        // self.navigationController!.popViewControllerAnimated(true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                }
            }
            catch  {
                print("error parsing response from POST on /posts")
                
                return "" as AnyObject
            }
                
        }
        
        return "" as AnyObject
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
