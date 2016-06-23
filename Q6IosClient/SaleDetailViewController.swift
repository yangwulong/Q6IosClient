//
//  saleDetailViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 3/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol {
    
    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    // @IBOutlet weak var lblsalesType: UILabel!
    @IBOutlet var saleDetailTableView: UITableView!
    //@IBOutlet weak var lblTotalAmount: UILabel!
    //@IBOutlet weak var lblTotalLabel: UILabel!
    
    var salesDetailScreenLinesDic = [ScreenSortLinesDetail]()
    
    var originalRowsDic: [Int: String] = [0: "SalesTypecell", 1: "CustomerCell",2: "DueDateCell",3: "AddanItemCell",4: "SubTotalCell",5: "TotalCell",6: "TransactionDateCell",7: "MemoCell",8: "AddanImageCell"]
    
    var addItemsDic = [Int:String]()
    
    var backFrom = String()
    
    var salesTransactionHeader = SalesTransactionsHeader()
    var salesTransactionsDetailData = [SalesTransactionsDetail]()
    
    var customer = Customer()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var attachedimage = UIImage?()
    
   
    var webAPICallAction: String = ""
    var operationType = String()
    var hasAddedItemLine = false
    var addItemRowIndex: Int = 0
    var isPreLoad = false
    var CompanyID = String()
    weak var delegate2: Q6GoBackFromViewTwo?
    override func viewWillAppear(animated: Bool) {
        
        
        print("SaleDetailViewController" + operationType)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setScreenSortLines()
        print("salesDetailScreenLinesDic" + salesDetailScreenLinesDic.count.description)
        setControlAppear()
        
        saleDetailTableView.delegate = self
        saleDetailTableView.dataSource = self
        
        if operationType == "Edit"
        {
            saleDetailTableView.hidden = true
            Q6ActivityIndicatorView.startAnimating()
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            let attachedURL = "&SalesTransactionsHeaderID=" + salesTransactionHeader.SalesTransactionsHeaderID
            isPreLoad = true
            q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetSalesTransactionsByID", attachedURL: attachedURL)
        }
        else {
            Q6ActivityIndicatorView.hidden = true
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            preloadFields()
        }
    }
    
    func preloadFields()
    {
        
        let q6DBLib = Q6DBLib()
        
        
        var dicData=[String:String]()
        var tempdicData = q6DBLib.getUserInfos()
        
        
        dicData["WebApiTOKEN"]=Q6CommonLib.getQ6WebAPIToken()
        dicData["LoginUserName"]=tempdicData["LoginEmail"]
        dicData["Password"]=tempdicData["PassWord"]
        dicData["ClientIP"]=Q6CommonLib.getIPAddresses()
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        webAPICallAction = "InternalUserLogin"
        isPreLoad = true
        q6CommonLib.Q6IosClientPostAPI("Q6",ActionName: "InternalUserLogin", dicData:dicData)
        
    }
    func setScreenSortLines()
    {
        if ValidteWhetherHasAddedLinesInsalesDetailScreenLinesDic() == false
        {
            for index in 0 ... 9 {
                
                let screenSortLinesDetail = ScreenSortLinesDetail()
                var prototypeCell = String()
                
                switch index {
                case 0:
                    prototypeCell = "SalesTypecell"
                case 1:
                    prototypeCell = "CustomerCell"
                case 2:
                    prototypeCell = "DueDateCell"
                case 3:
                    prototypeCell = "AddanItemCell"
                case 4:
                    prototypeCell = "SubTotalCell"
                case 5:
                    prototypeCell = "TotalCell"
                case 6:
                    prototypeCell = "TransactionDateCell"
                case 7:
                    prototypeCell = "MemoCell"
                case 8:
                    prototypeCell = "AddanImageCell"
                case 9:
                    prototypeCell = "SendEmailCell"
                default:
                    prototypeCell = ""
                }
                
                screenSortLinesDetail.ID = index
                screenSortLinesDetail.PrototypeCellID = prototypeCell
                screenSortLinesDetail.LineDescription = "OriginalLine"
                
                salesDetailScreenLinesDic.append(screenSortLinesDetail)
                
            }
        }
        
    }
    func setControlAppear()
    {
        // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        
        saleDetailTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // print("addItemsDic" + addItemsDic.count.description)
        // return originalRowsDic.count + addItemsDic.count
        return salesDetailScreenLinesDic.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var resuseIdentifier = String()
        //        if indexPath.row <= 8 {
        //       resuseIdentifier = originalRowsDic[indexPath.row]!
        //        }
        //        if indexPath.row > 8 {
        //             resuseIdentifier = originalRowsDic[5]!
        //        }
        
        var screenSortLinesDetail = salesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        
        resuseIdentifier = screenSortLinesDetail.PrototypeCellID
        let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! SaleDetailTableViewCell
        
        
        if resuseIdentifier == "SalesTypecell" {
            
            cell.lblSalesType.text = salesTransactionHeader.SalesType
            
            if operationType != "Create"{
                cell.SalesTypeButton.enabled = false
            }
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "CustomerCell" {
            
            cell.lblCustomerName.text = customer.CustomerName
            
            if operationType != "Create" {
                cell.CustomerButton.enabled = false
                
            }
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "DueDateCell" {
            
            
            if salesTransactionHeader.DueDate != nil {
                
                
                cell.lblDueDate.text = salesTransactionHeader.DueDate!.formatted
                
            }
            
            
            //
            
            
            
            
        }
        
        if resuseIdentifier == "AddanItemCell" {
            
            if salesDetailScreenLinesDic[indexPath.row].isAdded == true {
                
                let image = UIImage(named: "Minus-25") as UIImage?
                
                
                
                
                
                
                cell.AddDeleteButton.setImage(image, forState: .Normal)
                cell.LineDescription.text = salesDetailScreenLinesDic[indexPath.row].LineDescription
                
            }
            else {
                
                let image = UIImage(named: "plus") as UIImage?
                
                
                
                // let image = UIImage(named: "name") as UIImage?
                // cell.AddDeleteButton = UIButton(type: .System) as UIButton
                
                
                cell.AddDeleteButton.setImage(image, forState: .Normal)
                cell.LineDescription.text = "Add an Item"
                
                
            }
            
        }
        
        
        if resuseIdentifier == "SubTotalCell" {
            
            var subTotalAmount: Double = 0
            
            
            for i in 0 ..< salesDetailScreenLinesDic.count
            {
                if salesDetailScreenLinesDic[i].isAdded == true
                {
                    if salesDetailScreenLinesDic[i].salesTransactionsDetailView != nil {
                        
                        var salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                        
                        subTotalAmount = subTotalAmount + (salesTransactionsDetailView?.AmountWithoutTax)!
                    }
                }
            }
            
            
            cell.lblSubTotalAmount.text =  String(format: "%.2f", subTotalAmount)
            
            salesTransactionHeader.SubTotal = subTotalAmount
            
        }
        if resuseIdentifier == "TotalCell" {
            
            cell.lblTotalAmountLabel.font = UIFont.boldSystemFontOfSize(17.0)
            cell.lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
            
            var totalAmount: Double = 0
            for i in 0 ..< salesDetailScreenLinesDic.count
            {
                if salesDetailScreenLinesDic[i].isAdded == true
                {
                    if salesDetailScreenLinesDic[i].salesTransactionsDetailView != nil {
                        
                        var salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                        
                        totalAmount = totalAmount + (salesTransactionsDetailView?.Amount)!
                    }
                }
            }
            
            cell.lblTotalAmount.text =   String(format: "%.2f", totalAmount)
            
            salesTransactionHeader.TotalAmount = totalAmount
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "AddanImageCell" {
            
            if attachedimage != nil {
                
                cell.AddRemoveImageButton.setImage(UIImage(named: "Minus-25.png"), forState: UIControlState.Normal)
                cell.lblAddImageLabel.text = "Has a linked image!"
            }
            
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "TransactionDateCell" {
            
            //            if salesTransactionHeader.TransactionDate == nil {
            //
            //
            //                salesTransactionHeader.DueDate = NSDate()
            //            }
            
            //
            cell.lblTransactionDate.text = salesTransactionHeader.TransactionDate.formatted
            
            
            
        }
        if resuseIdentifier == "MemoCell" {
            
            
            cell.lblMemo.text = salesTransactionHeader.Memo
            
            
        }
        if resuseIdentifier == "SendEmailCell" {
            
            
            if operationType == "Create"
            {
                cell.btnSendEmail.enabled = false
                cell.SendEmailButton.enabled = false
            }
            else {
                cell.btnSendEmail.enabled = true
                cell.SendEmailButton.enabled = true
            }
            
        }
        
        return cell
        
        
        // Configure the cell...
        print("indexPath" + indexPath.row.description)
        
        //return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row //2
        
        print("Selected Row" + indexPath.row.description)
        var screenSortLinesDetail = salesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        print("screenSortLinesDetail.PrototypeCellID" + screenSortLinesDetail.PrototypeCellID)
        if screenSortLinesDetail.PrototypeCellID == "SalesTypecell" && operationType == "Create" {
            
            performSegueWithIdentifier("showPickerView", sender: "SalesTypecell")
            
            
        }
        print("screenSortLinesDetail.PrototypeCellID" + screenSortLinesDetail.PrototypeCellID)
        print("operationType" + operationType)
        if screenSortLinesDetail.PrototypeCellID == "CustomerCell" && operationType == "Create" {
            
            
            for item in  salesDetailScreenLinesDic
            {
                if item.isAdded == true
                {
                    hasAddedItemLine = true
                }
            }
            
            
            
            
            
            self.performSegueWithIdentifier("showContactSearch", sender: "CustomerCell")
            
            
            
            
            
        }
        if screenSortLinesDetail.PrototypeCellID == "DueDateCell" {
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegueWithIdentifier("showDueDate", sender: "DueDateCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Customer must be seleted!", viewController: self)
            }
            
            
        }
        
        
        
        if screenSortLinesDetail.PrototypeCellID == "AddanImageCell" {
            
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegueWithIdentifier("showPhoto", sender: "AddanImageCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Customer must be seleted!", viewController: self)
            }
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "AddanItemCell" {
            
            if salesTransactionHeader.CustomerID.length != 0 {
                addItemRowIndex = indexPath.row
                performSegueWithIdentifier("showItemDetail", sender: "AddanItemCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Customer must be seleted!", viewController: self)
            }
            
            
            
        }
        
        
        if screenSortLinesDetail.PrototypeCellID == "TransactionDateCell" {
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegueWithIdentifier("showTransactionDate", sender: "TransactionDateCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Customer must be seleted!", viewController: self)
            }
            
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "MemoCell" {
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegueWithIdentifier("showMemo", sender: "MemoCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Customer must be seleted!", viewController: self)
            }
            
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "SendEmailCell" {
            
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegueWithIdentifier("showSendEmail", sender: "SendEmailCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Customer must be seleted!", viewController: self)
            }
        }
        var index = addItemsDic.count
        addItemsDic[index] = "One more Item"
        // let section = indexPath.section//3
        //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //        self.saleDetailTableView.reloadData()
        //            })
        //        let order = menuItems.items[section][row] + " " + menuItems.sections[section] //4
        // navigationItem.title = order
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if salesDetailScreenLinesDic[indexPath.row].isAdded == true {
            return true
        }
        else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            if salesDetailScreenLinesDic[indexPath.row].isAdded == true
            {
                
                print("indexPath.row delete" + indexPath.row.description)
                salesDetailScreenLinesDic.removeAtIndex(indexPath.row)
                
                
                for i in 0 ..< salesDetailScreenLinesDic.count
                {
                    print("salesDetailScreenLinesDic[" + i.description + "].ID" + salesDetailScreenLinesDic[i].ID.description)
                    
                    print("salesDetailScreenLinesDic[" + i.description  + "].isAdded" + salesDetailScreenLinesDic[i].isAdded.description)
                    
                    print("salesDetailScreenLinesDic[" + i.description  + "].PrototypeCellID" +
                        salesDetailScreenLinesDic[i].PrototypeCellID)
                    
                    print("salesDetailScreenLinesDic[i].LineDescription"  + salesDetailScreenLinesDic[i].LineDescription)
                    
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saleDetailTableView.reloadData()
                    
                })
                
                
                
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if sender is String {
            
            let fromCell = sender as! String
            //        if let fromCell = sender as? String {
            
            
            
            
            if fromCell == "SalesTypecell"
            {
                var pickerViewController = segue.destinationViewController as! PickerViewViewController
                pickerViewController.fromCell = "SalesTypecell"
                
                pickerViewController.delegate = self
            }
            if fromCell == "CustomerCell"
            {
                
                var contactSearchViewController = segue.destinationViewController as! CustomerSearchViewController
                contactSearchViewController.fromCell = "CustomerCell"
                contactSearchViewController.delegate = self
                contactSearchViewController.hasAddedItemLine = hasAddedItemLine
                
            }
            
            if fromCell == "DueDateCell"
            {
                
                var datePickerViewController = segue.destinationViewController as! DatePickerViewController
                datePickerViewController.fromCell = "DueDateCell"
                datePickerViewController.delegate = self
                
            }
            
            if fromCell == "AddanItemCell"
            {
                var saleDetailDataLineViewController = segue.destinationViewController as! SaleDetailDataLineViewController
                saleDetailDataLineViewController.fromCell = "AddanItemCell"
                
                saleDetailDataLineViewController.customer = customer
                saleDetailDataLineViewController.delegate = self
                saleDetailDataLineViewController.salesTransactionHeader = salesTransactionHeader
                
                if salesDetailScreenLinesDic[addItemRowIndex].salesTransactionsDetailView != nil {
                    
                    saleDetailDataLineViewController.salesTransactionsDetailView = salesDetailScreenLinesDic[addItemRowIndex].salesTransactionsDetailView!
                }
            }
            
            if fromCell == "AddanImageCell"
            {
                var addImageViewController = segue.destinationViewController as! AddImageViewController
                addImageViewController.fromCell = "AddanImageCell"
                
                if attachedimage != nil
                {
                    addImageViewController.attachedImage = attachedimage
                }
                addImageViewController.delegate = self
            }
            
            if fromCell == "TransactionDateCell"
            {
                
                var datePickerViewController = segue.destinationViewController as! DatePickerViewController
                datePickerViewController.fromCell = "TransactionDateCell"
                datePickerViewController.delegate = self
                
            }
            
            if fromCell == "MemoCell"
            {
                
                var saleDetailMemoViewController = segue.destinationViewController as! SaleDetailMemoViewController
                saleDetailMemoViewController.fromCell = "MemoCell"
                
                saleDetailMemoViewController.delegate = self
                
                
                saleDetailMemoViewController.textValue = salesTransactionHeader.Memo
                
                
            }
            
            if fromCell == "SendEmailCell"
            {
                       var sendEmailViewController = segue.destinationViewController as! SendEmailViewController
                
                sendEmailViewController.salesTransactionHeader = salesTransactionHeader
                sendEmailViewController.customer = customer
                
            }
        }
        
    }
    
    @IBAction func SaveButtonClick(sender: AnyObject) {
        
        
        
        if validateQuantityValue()&&validateDate()&&validateIfSaleDetailIsNotEmpty()
        {
            Q6ActivityIndicatorView.hidden = false
            Q6ActivityIndicatorView.startAnimating()
            
            salesTransactionHeader.TaxTotal = salesTransactionHeader.TotalAmount - salesTransactionHeader.SubTotal
            
            
            var dicData=[String:AnyObject]()
            
            
            var q6DBLib = Q6DBLib()
            let q6CommonLib = Q6CommonLib(myObject: self)
            var userInfos = q6DBLib.getUserInfos()
            
            var LoginDetail = InternalUserLoginParameter()
            
            LoginDetail.LoginUserName = userInfos["LoginEmail"]!
            LoginDetail.Password = userInfos["PassWord"]!
            LoginDetail.ClientIP = Q6CommonLib.getIPAddresses()
            LoginDetail.WebApiTOKEN = Q6CommonLib.getQ6WebAPIToken()
            
            var NeedValidate = true
            
            
            
            var LoginDetailDicData = [String:AnyObject]()
            
            LoginDetailDicData["Email"] = userInfos["LoginEmail"]!
            LoginDetailDicData["Password"] = userInfos["PassWord"]!
            LoginDetailDicData["CompanyID"] = userInfos["CompanyID"]!
            LoginDetailDicData["WebApiTOKEN"] = Q6CommonLib.getQ6WebAPIToken()
            
            dicData["LoginDetail"] = LoginDetailDicData
            
              if attachedimage != nil {
            salesTransactionHeader.HasLinkedDoc = true
           
                var UploadedDocuments = getImageFileDataDic(attachedimage!)
                
                dicData["UploadedDocuments"] = UploadedDocuments
            }
            else{
                dicData["UploadedDocuments"] = nil
            }
            
            
            
            var salesTransactionsDetailDataDic = convertsalesTransactionsDetailDataTOArray()
            
            var salesTransactionsHeaderDic =   convertsalesTransactionsHeaderToArray()
            
            dicData["SalesTransactionsDetail"] = salesTransactionsDetailDataDic
            dicData["SalesTransactionsHeader"] = salesTransactionsHeaderDic
            dicData["RecurringTemplateList"] = nil
            
            dicData["NeedValidate"] = true
            var salesTransactionsParameter = [String: AnyObject]()
            
            salesTransactionsParameter["SalesTransactionsParameter"] = dicData
            
            isPreLoad = false
            
            if operationType == "Create" {
                q6CommonLib.Q6IosClientPostAPI("Sale",ActionName: "AddSale", dicData:dicData)
            }
            else if operationType == "Edit"{
                q6CommonLib.Q6IosClientPostAPI("Sale",ActionName: "EditSale", dicData:dicData)
            }
            
            
            
        }
    }
    
    func getImageFileDataDic(image: UIImage) -> [String: AnyObject]
    {
        
        var FileName = "AttachedPhoneImage"
        //
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((image), 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        var FileSize: Int = imgData.length
        print("File Size" + FileSize.description)
        var HasLinkedTransaction = false
        var LinkedTransactionID = String?()
        var TransactionType = String?()
        var UploadedBy = String?()
        
        var UploadedDate = NSDate().description
        var UploadedDocumentsID = "{00000000-0000-0000-0000-000000000000}"
        var i = CGFloat()
        if  FileSize > 2000000 {
            
            i = CGFloat (2000000 / FileSize)
            
        }
        else {
            i = 1
        }
        var imageData = UIImageJPEGRepresentation(image, i)
        var File = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        var dicData = [String: AnyObject]()
        
        dicData["File"] = File
        dicData["FileName"] = FileName
        dicData["FileSize"] = FileSize
        dicData["HasLinkedTransaction"] = HasLinkedTransaction
        dicData["TransactionType"] = TransactionType
        dicData["UploadedBy"] = UploadedBy
        dicData["UploadedDate"] = UploadedDate
        dicData["UploadedDocumentsID"] = UploadedDocumentsID
        
        return dicData
        //  print("size of image in KB: %f ", imageSize / 1024)
    }
    func convertsalesTransactionsHeaderToArray() -> [String: AnyObject]
    {
        var dicData = [String: AnyObject]()
        
        var SalesTransactionsHeaderID  = salesTransactionHeader.SalesTransactionsHeaderID
        
        if operationType == "Create" {
            dicData["SalesTransactionsHeaderID"] = "{00000000-0000-0000-0000-000000000000}"
        }
        else {
            dicData["SalesTransactionsHeaderID"] = SalesTransactionsHeaderID
        }
        dicData["ReferenceNo"] = salesTransactionHeader.ReferenceNo
        
        dicData["SalesType"] = salesTransactionHeader.SalesType
        dicData["SalesStatus"] = salesTransactionHeader.SalesStatus
        dicData["TransactionDate"] = salesTransactionHeader.TransactionDate.description
        
        print("salesTransactionHeader.TransactionDate.description" + salesTransactionHeader.TransactionDate.description)
        dicData["CreateTime"] = salesTransactionHeader.CreateTime.description
        
        //        var LastModifiedTime = NSDate()
        //        let dateFormatter = NSDateFormatter()
        //        //dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        //       // dateFormatter.timeStyle =  NSDateFormatterStyle.LongStyle
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        //       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //       var strLastModifiedTime = dateFormatter.stringFromDate(LastModifiedTime)
        //        print("strLastModifiedTime" + strLastModifiedTime)
        
        if operationType == "Create" {
            dicData["LastModifiedTime"] = salesTransactionHeader.CreateTime.description
        }
        else{
            dicData["LastModifiedTime"] = salesTransactionHeader.LastModifiedTime
        }
        
        dicData["CustomerID"] = salesTransactionHeader.CustomerID
        dicData["ShipToAddress"] = salesTransactionHeader.ShipToAddress
//        dicData["CustomerInv"] = salesTransactionHeader.CustomerInv
        dicData["Memo"] = salesTransactionHeader.Memo
        
        dicData["ClosedDate"] = salesTransactionHeader.ClosedDate?.description
        dicData["SubTotal"] = salesTransactionHeader.SubTotal
        dicData["TaxTotal"] = salesTransactionHeader.TaxTotal
        dicData["TotalAmount"] = salesTransactionHeader.TotalAmount
        dicData["DueDate"] = salesTransactionHeader.DueDate?.description
        dicData["TaxInclusive"] = salesTransactionHeader.TaxInclusive
        dicData["IsDeleted"] = salesTransactionHeader.IsDeleted
        dicData["IsCreatedByRecurring"] = salesTransactionHeader.IsCreatedByRecurring
        dicData["RecurringTemplateID"] = salesTransactionHeader.RecurringTemplateID
        dicData["HasLinkedDoc"] = salesTransactionHeader.HasLinkedDoc
        dicData["CustomerPurchaseNO"] = salesTransactionHeader.CustomerPurchaseNO
        return dicData
        
    }
    
    func convertsalesTransactionsDetailDataTOArray()->[[String : AnyObject]]
    {
        var dicData = [[String : AnyObject]]()
        
        if   salesTransactionsDetailData.count > 0
        {
            for i in 0..<salesTransactionsDetailData.count
            {
                
                var data = [String : AnyObject]()
                
                var SalesTransactionsDetailID = salesTransactionsDetailData[i].SalesTransactionsDetailID
                if operationType == "Create"{
                    data["SalesTransactionsDetailID"] = "{00000000-0000-0000-0000-000000000000}"
                }
                else {
                    data["SalesTransactionsDetailID"] = SalesTransactionsDetailID
                }
                
                
                
                var SalesTransactionsHeaderID = salesTransactionsDetailData[i].SalesTransactionsHeaderID
                
                if operationType == "Create" {
                    data["SalesTransactionsHeaderID"] = "{00000000-0000-0000-0000-000000000000}"
                }
                else {
                    data["SalesTransactionsHeaderID"] = SalesTransactionsHeaderID
                }
                data["Quantity"] = salesTransactionsDetailData[i].Quantity
                
                data["InventoryID"] = salesTransactionsDetailData[i].InventoryID
                data["AccountID"] = salesTransactionsDetailData[i].AccountID
                data["TaxCodeID"] = salesTransactionsDetailData[i].TaxCodeID
                data["Description"] = salesTransactionsDetailData[i].Description
                
                data["UnitPrice"] = salesTransactionsDetailData[i].UnitPrice
                data["Discount"] = salesTransactionsDetailData[i].Discount
                data["Amount"] = salesTransactionsDetailData[i].Amount
                
                data["IsDeleted"] = salesTransactionsDetailData[i].IsDeleted
                data["SortNo"] = salesTransactionsDetailData[i].SortNo
                
                dicData.append(data)
                
            }
        }
        
        return dicData
    }
    
    
    func validateIfSaleDetailIsNotEmpty() -> Bool
    {
        var IsNotEmpty = true
        copyFromSalesTransactionDetailViewToSalesTransactionDetail()
        if salesTransactionsDetailData.count <= 0
        {
            Q6CommonLib.q6UIAlertPopupController("Information message", message: "You need to add at least one data line before you save sale transaction !", viewController: self)
            
            IsNotEmpty = false
        }
        
        return IsNotEmpty
        
    }
    func validateDate()-> Bool
    {
        var isValid = true
        if salesTransactionHeader.SalesType == "INVOICE"
        {
            if salesTransactionHeader.DueDate == nil
            {
                
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "Due Date can not be empty if sale type is Invoice!", viewController: self)
                isValid = false
            }
        }
        
        if salesTransactionHeader.DueDate != nil {
            
            var DueDate = salesTransactionHeader.DueDate
            var TransactionDate = salesTransactionHeader.TransactionDate
            
            var isEalierOrEqual = (DueDate?.isLaterOrEqualThanDate(TransactionDate))! as Bool
            
            if isEalierOrEqual == false {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "Due Date can not be later than TransactionDate!", viewController: self)
                isValid = false
            }
        }
        return isValid
    }
    func validateQuantityValue() -> Bool
    {
        var isValid = true
        if salesTransactionHeader.SalesType == "CREDIT NOTE"
        {
            for i in 0..<salesDetailScreenLinesDic.count
            {
                var salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                
                if salesTransactionsDetailView != nil && salesDetailScreenLinesDic[i].isAdded == true
                {
                    if  salesTransactionsDetailView!.Quantity > 0
                    {
                        Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input positive amount at quantity field when sale type is CREDIT NOTE!", viewController: self)
                        isValid = false
                        
                    }
                }
            }
            
        }
        else {
            for i in 0..<salesDetailScreenLinesDic.count
            {
                var salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                
                if salesTransactionsDetailView != nil && salesDetailScreenLinesDic[i].isAdded == true
                {
                    if  salesTransactionsDetailView!.Quantity < 0
                    {
                        Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input negative amount at quantity field when sale type is QUOTE,ORDER ,INVOICE!", viewController: self)
                        isValid = false
                    }
                }
            }
            
        }
        
        return isValid
    }

    func copyFromSalesTransactionDetailViewToSalesTransactionDetail()
    {
        salesTransactionsDetailData.removeAll()
        
        var sortNo: Int = 0
        for i in 0..<salesDetailScreenLinesDic.count
        {
            var salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
            if salesTransactionsDetailView != nil && salesDetailScreenLinesDic[i].isAdded == true
            {
                var salesTransactionsDetail = SalesTransactionsDetail()
                
                salesTransactionsDetail.AccountID = salesTransactionsDetailView!.AccountID
                salesTransactionsDetail.Amount = salesTransactionsDetailView!.Amount
                salesTransactionsDetail.Description = salesTransactionsDetailView!.Description
                salesTransactionsDetail.Discount = salesTransactionsDetailView!.Discount
                salesTransactionsDetail.InventoryID = salesTransactionsDetailView!.InventoryID
                salesTransactionsDetail.IsDeleted = salesTransactionsDetailView!.IsDeleted
                salesTransactionsDetail.SalesTransactionsDetailID = salesTransactionsDetailView!.SalesTransactionsDetailID
                
                salesTransactionsDetail.SalesTransactionsHeaderID = salesTransactionsDetailView!.SalesTransactionsHeaderID
                
                salesTransactionsDetail.Quantity = salesTransactionsDetailView!.Quantity
                salesTransactionsDetail.SortNo = sortNo
                sortNo = sortNo + 1
                
                salesTransactionsDetail.TaxCodeID = salesTransactionsDetailView!.TaxCodeID
                salesTransactionsDetail.UnitPrice = salesTransactionsDetailView!.UnitPrice
                
                salesTransactionsDetailData.append(salesTransactionsDetail)
            }
        }
        
        print("salesTransactionsDetailData.count" + salesTransactionsDetailData.count.description)
        
    }
    
    func copyFromSalesTransactionDetailViewToSalesTransactionDetailForEdit(salesTransactionsDetailList: [SalesTransactionsDetailView])
    {
        salesTransactionsDetailData.removeAll()
        
        for i in 0 ..< salesTransactionsDetailList.count
        {
            var salesTransactionDetail = SalesTransactionsDetail()
            salesTransactionDetail.AccountID = salesTransactionsDetailList[i].AccountID
            
            salesTransactionDetail.Amount = salesTransactionsDetailList[i].Amount
            salesTransactionDetail.Description = salesTransactionsDetailList[i].Description
            salesTransactionDetail.InventoryID = salesTransactionsDetailList[i].InventoryID
            salesTransactionDetail.SalesTransactionsDetailID = salesTransactionsDetailList[i].SalesTransactionsDetailID
            salesTransactionDetail.SalesTransactionsHeaderID = salesTransactionsDetailList[i].SalesTransactionsHeaderID
            salesTransactionDetail.Quantity = salesTransactionsDetailList[i].Quantity
            salesTransactionDetail.SortNo = salesTransactionsDetailList[i].SortNo
            salesTransactionDetail.TaxCodeID = salesTransactionsDetailList[i].TaxCodeID
            salesTransactionDetail.UnitPrice = salesTransactionsDetailList[i].UnitPrice
            
            salesTransactionsDetailData.append(salesTransactionDetail)
            
            var screenSortLinesDetail = ScreenSortLinesDetail()
            screenSortLinesDetail.ID = 3 + i
            screenSortLinesDetail.isAdded = true
            screenSortLinesDetail.LineDescription = salesTransactionsDetailList[i].InventoryName + salesTransactionsDetailList[i].AccountNameWithAccountNo
            screenSortLinesDetail.salesTransactionsDetailView = salesTransactionsDetailList[i]
            screenSortLinesDetail.PrototypeCellID = "AddanItemCell"
            
            salesDetailScreenLinesDic.insert(screenSortLinesDetail, atIndex: screenSortLinesDetail.ID)
            
            
        }
        
        print("salesTransactionsDetailData" + salesTransactionsDetailData.count.description)
        print("salesDetailScreenLinesDic" + salesDetailScreenLinesDic.count.description)
        //        var sortNo: Int = 0
        //        for i in 0..<salesDetailScreenLinesDic.count
        //        {
        //            var salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
        //            if salesTransactionsDetailView != nil && salesDetailScreenLinesDic[i].isAdded == true
        //            {
        //                var salesTransactionsDetail = salesTransactionsDetail()
        //
        //                salesTransactionsDetail.AccountID = salesTransactionsDetailView!.AccountID
        //                salesTransactionsDetail.Amount = salesTransactionsDetailView!.Amount
        //                salesTransactionsDetail.Description = salesTransactionsDetailView!.Description
        //                salesTransactionsDetail.Discount = salesTransactionsDetailView!.Discount
        //                salesTransactionsDetail.InventoryID = salesTransactionsDetailView!.InventoryID
        //                salesTransactionsDetail.IsDeleted = salesTransactionsDetailView!.IsDeleted
        //                salesTransactionsDetail.salesTransactionsDetailID = salesTransactionsDetailView!.salesTransactionsDetailID
        //
        //                salesTransactionsDetail.salesTransactionsHeaderID = salesTransactionsDetailView!.salesTransactionsHeaderID
        //
        //                salesTransactionsDetail.Quantity = salesTransactionsDetailView!.Quantity
        //                salesTransactionsDetail.SortNo = sortNo
        //                sortNo = sortNo + 1
        //
        //                salesTransactionsDetail.TaxCodeID = salesTransactionsDetailView!.TaxCodeID
        //                salesTransactionsDetail.UnitPrice = salesTransactionsDetailView!.UnitPrice
        //
        //                salesTransactionsDetailData.append(salesTransactionsDetail)
        //            }
        //        }
        //
        //        print("salesTransactionsDetailData.count" + salesTransactionsDetailData.count.description)
        
    }
    @IBAction func CancelButtonClick(sender: AnyObject) {
        
        //        if let saleViewController = storyboard!.instantiateViewControllerWithIdentifier("saleViewController") as? saleViewController {
        //
        //            presentViewController(saleViewController, animated: true, completion: nil)
        //        }
        //navigationController?.popViewControllerAnimated(true)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    //    func performFromRightToLeft(sourceViewController :AnyObject , destinationViewController: AnyObject)
    //    {
    //        let src = sourceViewController.sourceViewController
    //        let dst = destinationViewController.destinationViewController
    //
    //        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
    //        dst.view.transform = CGAffineTransformMakeTranslation(-src.view.frame.size.width, 0)
    //
    //        UIView.animateWithDuration(0.25,
    //                                   delay: 0.0,
    //                                   options: UIViewAnimationOptions.CurveEaseInOut,
    //                                   animations: {
    //                                    dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
    //            },
    //                                   completion: { finished in
    //        })
    //
    //
    //    }
    func searchLastAddedIndexInsaleDetailScreenLinesDic() -> Int? {
        
        var indexPath = Int?()
        
        
        for index in 0 ..< salesDetailScreenLinesDic.count {
            var screenSortLinesDetail = salesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
            if screenSortLinesDetail.isAdded == true {
                indexPath = index
            }
        }
        return indexPath
    }
    
    func ValidteWhetherHasAddedLinesInsalesDetailScreenLinesDic() -> Bool {
        
        for index in 0 ..< salesDetailScreenLinesDic.count {
            var screenSortLinesDetail = salesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
            if screenSortLinesDetail.isAdded == true {
                return true
            }
            
        }
        return false
    }
    func sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String)
    {
        self.backFrom = fromView
        
        if fromView == "fromPickerViewViewController" {
            if forCell == "SalesTypecell" {
                
                salesTransactionHeader.SalesType = selectedValue
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saleDetailTableView.reloadData()
                    
                })
                
            }
        }
        print("backFrom" + self.backFrom)
    }
    
      func  sendGoBackFromSupplierSearchView(fromView : String ,forCell: String,Contact: Supplier)
      {}
    func  sendGoBackFromCustomerSearchView(fromView : String ,forCell: String,Contact:Customer){
        
        if fromView == "CustomerSearchViewController" {
            if forCell == "CustomerCell" {
                salesTransactionHeader.CustomerID = Contact.CustomerID
                
                customer = Contact
                
                print("salesTransactionHeader.CustomerID" + salesTransactionHeader.CustomerID)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saleDetailTableView.reloadData()
                    
                })
            }
        }
        
        
    }
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
    {
        if fromView == "DatePickerViewController" {
            if forCell == "DueDateCell" {
                salesTransactionHeader.DueDate = Date
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saleDetailTableView.reloadData()
                    
                })
                
            }
            
            if forCell == "TransactionDateCell" {
                salesTransactionHeader.TransactionDate = Date
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saleDetailTableView.reloadData()
                    
                })
                
            }
            
        }
        
    }
    
    
    func sendGoBackFromSaleDetailDataLineView(fromView:String,forCell:String,salesTransactionsDetailView: SalesTransactionsDetailView){
        
        if salesDetailScreenLinesDic[addItemRowIndex].isAdded == false{
            
            var screenSortLinesDetail = ScreenSortLinesDetail()
            screenSortLinesDetail.isAdded = true
            screenSortLinesDetail.ID = addItemRowIndex
            screenSortLinesDetail.LineDescription = salesTransactionsDetailView.InventoryName + " " + salesTransactionsDetailView.AccountNameWithAccountNo
            screenSortLinesDetail.PrototypeCellID = "AddanItemCell"
            screenSortLinesDetail.salesTransactionsDetailView = salesTransactionsDetailView
            salesDetailScreenLinesDic.insert(screenSortLinesDetail, atIndex: addItemRowIndex)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.saleDetailTableView.reloadData()
                
            })
        }
        else{
            salesDetailScreenLinesDic[addItemRowIndex].LineDescription = salesTransactionsDetailView.InventoryName + " " + salesTransactionsDetailView.AccountNameWithAccountNo
            salesDetailScreenLinesDic[addItemRowIndex].salesTransactionsDetailView = salesTransactionsDetailView
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.saleDetailTableView.reloadData()
                
            })
        }
    }
    func sendGoBackFromSaleDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView){
        
    }
    
    func  sendGoBackFromSaleDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {
        
    }
    func  sendGoBackFromSaleDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    {
        
    }
    
    func  sendGoBackFromSaleDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    {
        
    }
    
    func sendGoBackFromAddImageView(fromView: String, forCell: String, image:UIImage)
    {
        if fromView == "AddImageViewController" {
            if forCell == "AddanImageCell" {
                attachedimage = image
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.saleDetailTableView.reloadData()
                    
                })
                
            }
        }
    }
    
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        if operationType == "Edit" && isPreLoad == true {
            
            var postDicData :[String:AnyObject]
            
            do {
                //                if dataRequestSource == "Search" {
                //                    CustomerData.removeAll()
                //                    selectedSuplier = nil
                //                }
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                var returnSalesTransactionHeaderData = postDicData["SalesTransactionsHeader"]  as? [String:AnyObject]
                
                if returnSalesTransactionHeaderData != nil {
                    
                    var salesTransactionsHeaderView =   initialSalesTransactionsHeaderView(returnSalesTransactionHeaderData!)
                    
                    copyFromSalesTransactionsHeaderViewToSalesTransactionsHeader(salesTransactionsHeaderView)
                    
                    
                }
                
                var returnSalesTransactionsDetailListData = postDicData["SalesTransactionsDetailList"]  as? [[String:AnyObject]]
                
                
                if returnSalesTransactionsDetailListData != nil {
                    
                    var salesTransactionsDetailView =    initialSalesTransactionsDetailListView(returnSalesTransactionsDetailListData!)
                    
                    copyFromSalesTransactionDetailViewToSalesTransactionDetailForEdit(salesTransactionsDetailView)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.saleDetailTableView.reloadData()
                        //                        self.Q6ActivityIndicatorView.hidesWhenStopped = true
                        //                        self.Q6ActivityIndicatorView.stopAnimating()
                        //                        self.ContactSearchBox.resignFirstResponder()
                        
                        self.saleDetailTableView.hidden = false
                        self.Q6ActivityIndicatorView.hidesWhenStopped = true
                        self.Q6ActivityIndicatorView.stopAnimating()
                    })
                    
                }
            } catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
            
            
        }
        
        if isPreLoad == true && operationType == "Create" {
            
            
            
            var postDicData :[String:AnyObject]
            var IsLoginSuccessed : Bool
            do {
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                
                IsLoginSuccessed = postDicData["IsSuccessed"] as! Bool
                
                
                if IsLoginSuccessed == true {
                    
                    var q6CommonLib = Q6CommonLib()
                    var returnValue = postDicData["ReturnValue"]! as! Dictionary<String, AnyObject>
                    //
                    var shippingAddress = ShippingAddress()
                    var Address = returnValue["ShippingAddress"] as? String
                    
                    
                    if Address != nil {
                        shippingAddress.ShippingAddress = Address!
                    }
                    var  ShippingAddressLine2 = returnValue["ShippingAddressLine2"] as? String
                    
                    if ShippingAddressLine2 != nil {
                        shippingAddress.ShippingAddressLine2 = ShippingAddressLine2!
                    }
                    
                    var  ShippingCity = returnValue["ShippingCity"] as? String
                    
                    if ShippingCity != nil {
                        shippingAddress.ShippingCity = ShippingCity!
                    }
                    var ShippingCountry = returnValue["ShippingCountry"] as? String
                    
                    if ShippingCountry != nil {
                        shippingAddress.ShippingCountry = ShippingCountry!
                    }
                    
                    var ShippingPostalCode = returnValue["ShippingPostalCode"] as? String
                    
                    if ShippingPostalCode != nil {
                        shippingAddress.ShippingPostalCode = ShippingPostalCode!
                    }
                    
                    var ShippingState = returnValue["ShippingState"] as? String
                    
                    if ShippingState != nil {
                        shippingAddress.ShippingState = ShippingState!
                    }
                    
                    var RealCompanyName = returnValue["RealCompanyName"] as? String
                    
                    if RealCompanyName != nil {
                        shippingAddress.RealCompanyName = RealCompanyName!
                    }
                    salesTransactionHeader.ShipToAddress = shippingAddress.getShippingAddressStr()
                    
                    print("salesTransactionHeader.ShipToAddress" + salesTransactionHeader.ShipToAddress)
                    //                //var json = try  NSJSONSerialization.JSONObjectWithData(dd as! NSData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, String>
                    //
                    //                let q6DBLib = Q6DBLib()
                    //
                    //
                    //                q6DBLib.addUserInfos(txtLoginEmail.text!, PassWord: txtLoginPassword.text!, LoginStatus: "Login",CompanyID: companyID)
                    //                //Set any attributes of the view controller before it is displayed, this is where you would set the category text in your code.
                    //
                    //                var passCode = q6DBLib.getUserPassCode()
                    //
                    //
                    //
                    //                if let passCodeViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6PassCodeViewController") as? PassCodeViewController {
                    //
                    //                    if passCode == nil {
                    //
                    //                        passCodeViewController.ScreenMode = "CreatePassCode"
                    //                    }
                    //                    else {
                    //                        passCodeViewController.ScreenMode = "ValidatePassCode"
                    //                    }
                    //                    presentViewController(passCodeViewController, animated: true, completion: nil)
                    //                }
                    //
                }
                //
                //
            } catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
        }
        
        if isPreLoad == false && (operationType == "Create"||operationType == "Edit") {
            
            var postDicData :[String:AnyObject]
            var IsSuccessed : Bool?
            
            do {
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                IsSuccessed = postDicData["IsSuccessed"] as? Bool
                if IsSuccessed != nil {
                    IsSuccessed = postDicData["IsSuccessed"] as! Bool
                }
                ////                else{
                //                var message = postDicData["Message"] as! String
                //                print("Message" + message)
                ////                }
                if IsSuccessed == true {
                    
                    var nav = navigationController
                    // Q6CommonLib.q6UIAlertPopupControllerThenGoBack("Information message", message: "Save Successfully!", viewController: self,timeArrange:3,navigationController: nav!)
                    
                    
                    let alert = UIAlertController(title: "Information message", message: "Save Successfully!", preferredStyle: UIAlertControllerStyle.Alert)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
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
                        
                        self.delegate2?.sendGoBackSaleDetailView("SaleDetailViewController", fromButton: "Save")
                        self.navigationController!.popViewControllerAnimated(true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    //self.navigationController!.popViewControllerAnimated(true)
                    //                     public static func q6UIAlertPopupControllerThenGoBack(title: String?,message:String?,viewController: AnyObject? ,timeArrange: Double ,navigationController: UINavigationController)
                    //                    var q6CommonLib = Q6CommonLib()
                    //                    var returnValue = postDicData["ReturnValue"]! //as! Dictionary<String, AnyObject>
                    
                    // navigationController?.popViewControllerAnimated(true)
                    
                    //
                }
                else {
                    Q6CommonLib.q6UIAlertPopupController("Information message", message: "Save Fail!", viewController: self, timeArrange:2)
                }
                
            } catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
            
            
        }
        
        //
        return ""
    }
    
    func initialSalesTransactionsDetailListView(returnSalesTransactionDetailListData : [[String: AnyObject]]) ->[SalesTransactionsDetailView]
    {
        var salesTransactionsDetailViewList = [SalesTransactionsDetailView]()
        
        for i in 0..<returnSalesTransactionDetailListData.count
        {
            var salesTransactionsDetailView = SalesTransactionsDetailView()
            
            salesTransactionsDetailView.AccountID = returnSalesTransactionDetailListData[i]["AccountID"] as! String
            salesTransactionsDetailView.AccountNameWithAccountNo = returnSalesTransactionDetailListData[i]["AccountNameWithAccountNo"] as! String
            
            
            salesTransactionsDetailView.Amount = returnSalesTransactionDetailListData[i]["Amount"] as! Double
            
            
            salesTransactionsDetailView.Description = returnSalesTransactionDetailListData[i]["Description"] as! String
            
            salesTransactionsDetailView.InventoryID = returnSalesTransactionDetailListData[i]["InventoryID"] as? String
            
            salesTransactionsDetailView.InventoryName = returnSalesTransactionDetailListData[i]["InventoryName"] as! String
            
            salesTransactionsDetailView.SalesTransactionsDetailID = returnSalesTransactionDetailListData[i]["SalesTransactionsDetailID"] as! String
            
            salesTransactionsDetailView.SalesTransactionsHeaderID = returnSalesTransactionDetailListData[i]["SalesTransactionsHeaderID"] as! String
            
            salesTransactionsDetailView.Quantity = returnSalesTransactionDetailListData[i]["Quantity"] as! Double
            salesTransactionsDetailView.SortNo = i
            
            salesTransactionsDetailView.TaxCodeID = returnSalesTransactionDetailListData[i]["TaxCodeID"] as? String
            
            salesTransactionsDetailView.TaxCodeName = returnSalesTransactionDetailListData[i]["TaxCodeName"] as! String
            
            salesTransactionsDetailView.TaxCodeRate = returnSalesTransactionDetailListData[i]["TaxCodeRate"] as? Double
            
            if salesTransactionsDetailView.TaxCodeRate != nil
            {
                print("salesTransactionsDetailView.TaxCodeRate" + salesTransactionsDetailView.TaxCodeRate!.description)
            }
            else{
                print("salesTransactionsDetailView.TaxCodeRate  nil")
            }
            
            
            salesTransactionsDetailView.UnitPrice = returnSalesTransactionDetailListData[i]["UnitPrice"] as! Double
            
            
            if salesTransactionsDetailView.TaxCodeID != nil {
                
                var taxCodeRate = salesTransactionsDetailView.TaxCodeRate
                
                var amount = salesTransactionsDetailView.Amount
                
                salesTransactionsDetailView.AmountWithoutTax = amount / (1 + taxCodeRate!/100)
                
                
            }
            
            salesTransactionsDetailViewList.append(salesTransactionsDetailView)
            
            
        }
        
        return salesTransactionsDetailViewList
    }
    func initialSalesTransactionsHeaderView(returnsalesTransactionHeaderData : [String: AnyObject]!) -> SalesTransactionsHeaderView
    {
        
        var salesTransactionsHeaderView = SalesTransactionsHeaderView()
        salesTransactionsHeaderView.ClosedDate = returnsalesTransactionHeaderData!["ClosedDate"] as? NSDate
        
        
        
        var DueDate = returnsalesTransactionHeaderData!["DueDate"] as? String
        
        if DueDate != nil {
            print("DueDate" + DueDate!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            salesTransactionsHeaderView.DueDate = dateFormatter.dateFromString(DueDate!)
        }
        else{
            salesTransactionsHeaderView.DueDate = nil
        }
        // salesTransactionsHeaderView.DueDate = returnsalesTransactionHeaderData!["DueDate"] as? NSDate
        
        if salesTransactionsHeaderView.DueDate != nil {
            
            print("salesTransactionsHeaderView.DueDate" + salesTransactionsHeaderView.DueDate!.description)
        }
        else {
            print("salesTransactionsHeaderView.DueDate nil")
        }
        
        salesTransactionsHeaderView.HasLinkedDoc = returnsalesTransactionHeaderData!["HasLinkedDoc"] as! Bool
        
        
        
        var LastModifiedTime = returnsalesTransactionHeaderData!["LastModifiedTime"] as! String
        
        
        //        let dateFormatter = NSDateFormatter()
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        salesTransactionsHeaderView.LastModifiedTime = LastModifiedTime
        
        
        
        
        salesTransactionsHeaderView.LinkDocumentFile = returnsalesTransactionHeaderData!["LinkDocumentFile"] as? String
        
        
        
        salesTransactionsHeaderView.LinkDocumentFileName = returnsalesTransactionHeaderData!["LinkDocumentFileName"] as? String
        
        
        salesTransactionsHeaderView.LinkDocumentFileSize = returnsalesTransactionHeaderData!["LinkDocumentFileSize"] as? Double
        
        
        
        
        salesTransactionsHeaderView.Memo = returnsalesTransactionHeaderData!["Memo"] as! String
        
        salesTransactionsHeaderView.SalesStatus = returnsalesTransactionHeaderData!["SalesStatus"] as! String
        salesTransactionsHeaderView.SalesTransactionsHeaderID = returnsalesTransactionHeaderData!["SalesTransactionsHeaderID"] as! String
        
        salesTransactionsHeaderView.SalesType = returnsalesTransactionHeaderData!["SalesType"] as! String
        
        salesTransactionsHeaderView.ReferenceNo = returnsalesTransactionHeaderData!["ReferenceNo"] as! String
        
        salesTransactionsHeaderView.ShipToAddress = returnsalesTransactionHeaderData!["ShipToAddress"] as! String
        salesTransactionsHeaderView.SubTotal = returnsalesTransactionHeaderData!["SubTotal"] as! Double
        
        salesTransactionsHeaderView.CustomerID = returnsalesTransactionHeaderData!["CustomerID"] as! String
        
//        salesTransactionsHeaderView.CustomerInv = returnsalesTransactionHeaderData!["CustomerInv"] as! String
        salesTransactionsHeaderView.CustomerName = returnsalesTransactionHeaderData!["CustomerName"] as! String
        
        customer.CustomerID = salesTransactionsHeaderView.CustomerID
        customer.CustomerName = salesTransactionsHeaderView.CustomerName
        salesTransactionsHeaderView.TaxInclusive = returnsalesTransactionHeaderData!["TaxInclusive"] as! Bool
        
        salesTransactionsHeaderView.TaxTotal = returnsalesTransactionHeaderData!["TaxTotal"] as! Double
        salesTransactionsHeaderView.TotalAmount = returnsalesTransactionHeaderData!["TotalAmount"] as! Double
        
        
        
        
        var TransactionDate  = returnsalesTransactionHeaderData!["TransactionDate"] as! String
        
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.timeZone = NSTimeZone(name: "UTC")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        salesTransactionsHeaderView.TransactionDate = dateFormatter2.dateFromString(TransactionDate)!
        
        salesTransactionsHeaderView.UploadedDocumentsID = returnsalesTransactionHeaderData!["UploadedDocumentsID"] as? String
        
        if salesTransactionsHeaderView.UploadedDocumentsID != nil {
            
            var imageDataStr = salesTransactionsHeaderView.LinkDocumentFile
            
            
            let imageData = NSData(base64EncodedString: imageDataStr!, options: NSDataBase64DecodingOptions(rawValue: 0))
            attachedimage = UIImage(data: imageData!)
            print("salesTransactionsHeaderView.UploadedDocumentsID" + salesTransactionsHeaderView.UploadedDocumentsID!)
        }
        else {
            print("salesTransactionsHeaderView.UploadedDocumentsID nil")
        }
        
        
        return  salesTransactionsHeaderView
    }
    
    func copyFromSalesTransactionsHeaderViewToSalesTransactionsHeader(salesTransactionsHeaderView:SalesTransactionsHeaderView)
    {
        salesTransactionHeader.ClosedDate = salesTransactionsHeaderView.ClosedDate
        salesTransactionHeader.CreateTime = salesTransactionsHeaderView.CreateTime
        salesTransactionHeader.DueDate = salesTransactionsHeaderView.DueDate
        salesTransactionHeader.HasLinkedDoc = salesTransactionsHeaderView.HasLinkedDoc
        salesTransactionHeader.IsDeleted = salesTransactionsHeaderView.IsDeleted
        salesTransactionHeader.LastModifiedTime = salesTransactionsHeaderView.LastModifiedTime
        salesTransactionHeader.Memo = salesTransactionsHeaderView.Memo
        salesTransactionHeader.SalesStatus = salesTransactionsHeaderView.SalesStatus
        salesTransactionHeader.SalesTransactionsHeaderID = salesTransactionsHeaderView.SalesTransactionsHeaderID
        salesTransactionHeader.SalesType = salesTransactionsHeaderView.SalesType
        salesTransactionHeader.ReferenceNo = salesTransactionsHeaderView.ReferenceNo
        
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationBar.topItem?.title = self.salesTransactionHeader.ReferenceNo
        }
        
        salesTransactionHeader.ShipToAddress = salesTransactionsHeaderView.ShipToAddress
        salesTransactionHeader.SubTotal = salesTransactionsHeaderView.SubTotal
        salesTransactionHeader.CustomerID = salesTransactionsHeaderView.CustomerID
//        salesTransactionHeader.CustomerInv = salesTransactionsHeaderView.CustomerInv
        salesTransactionHeader.TaxInclusive = salesTransactionsHeaderView.TaxInclusive
        salesTransactionHeader.TaxTotal = salesTransactionsHeaderView.TaxTotal
        salesTransactionHeader.TotalAmount = salesTransactionsHeaderView.TotalAmount
        salesTransactionHeader.TransactionDate = salesTransactionsHeaderView.TransactionDate
        
        salesTransactionHeader.SubTotal = salesTransactionHeader.TotalAmount - salesTransactionHeader.TaxTotal
        salesTransactionHeader.CustomerPurchaseNO = ""
    }
    func  sendGoBackFromSaleDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {
        salesTransactionHeader.Memo = Memo
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.saleDetailTableView.reloadData()
            
        })
        
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


func  sendGoBackFromPurchaseDetailMemoView(fromView : String ,forCell: String,Memo: String)
{}
   
    //    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    //    {
    //
    //
    //
    //
    //        var postDicData :[String:AnyObject]
    //        var IsLoginSuccessed : Bool
    //        do {
    //            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
    //
    ////
    ////            IsLoginSuccessed = postDicData["IsSuccessed"] as! Bool
    ////
    ////
    ////            if IsLoginSuccessed == true {
    ////
    ////                var q6CommonLib = Q6CommonLib()
    ////                var returnValue = postDicData["ReturnValue"]! as! Dictionary<String, AnyObject>
    ////
    ////                var companyID = returnValue["CompanyID"] as! String
    ////
    ////                //var json = try  NSJSONSerialization.JSONObjectWithData(dd as! NSData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, String>
    ////
    ////                let q6DBLib = Q6DBLib()
    ////
    ////
    ////                q6DBLib.addUserInfos(txtLoginEmail.text!, PassWord: txtLoginPassword.text!, LoginStatus: "Login",CompanyID: companyID)
    ////                //Set any attributes of the view controller before it is displayed, this is where you would set the category text in your code.
    ////
    ////                var passCode = q6DBLib.getUserPassCode()
    ////
    ////
    ////
    ////                if let passCodeViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6PassCodeViewController") as? PassCodeViewController {
    ////
    ////                    if passCode == nil {
    ////
    ////                        passCodeViewController.ScreenMode = "CreatePassCode"
    ////                    }
    ////                    else {
    ////                        passCodeViewController.ScreenMode = "ValidatePassCode"
    ////                    }
    ////                    presentViewController(passCodeViewController, animated: true, completion: nil)
    ////                }
    ////
    ////            }
    //
    //
    //        } catch  {
    //            print("error parsing response from POST on /posts")
    //
    //            return ""
    //        }
    //
    //        //
    //        return ""
    //    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

