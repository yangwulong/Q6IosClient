//
//  saleDetailViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 3/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol {
    
    
    @IBOutlet weak var btnSaveButton: UIBarButtonItem!
    @IBOutlet weak var btnCancelButton: UIBarButtonItem!
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
    var attachedimage:UIImage?
    
    var webAPICallAction: String = ""
    var operationType = String()
    var hasAddedItemLine = false
    var addItemRowIndex: Int = 0
    var isPreLoad = false
    var CompanyID = String()
    weak var delegate2: Q6GoBackFromViewTwo?
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("SaleDetailViewController" + operationType)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(customer.CustomerID, customer.CustomerName)
        setScreenSortLines()
        print("salesDetailScreenLinesDic" + salesDetailScreenLinesDic.count.description)
        setControlAppear()
        
        saleDetailTableView.delegate = self
        saleDetailTableView.dataSource = self
        
        if operationType == "Edit" {
            
            saleDetailTableView.isHidden = true
            Q6ActivityIndicatorView.startAnimating()
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            let attachedURL = "&SalesTransactionsHeaderID=" + salesTransactionHeader.SalesTransactionsHeaderID
            isPreLoad = true
            q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetSalesTransactionsByID", attachedURL: attachedURL)
        } else {
            Q6ActivityIndicatorView.isHidden = true
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            preloadFields()
        }
    }
    
    func preloadFields() {
        
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
        q6CommonLib.Q6IosClientPostAPI(ModeName: "Q6",ActionName: "InternalUserLogin", dicData:dicData as [String : AnyObject])
        
    }
    func setScreenSortLines() {
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
        
        saleDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    // MARK: - Table view data source
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // print("addItemsDic" + addItemsDic.count.description)
        // return originalRowsDic.count + addItemsDic.count
        return salesDetailScreenLinesDic.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resuseIdentifier = String()
        //        if indexPath.row <= 8 {
        //       resuseIdentifier = originalRowsDic[indexPath.row]!
        //        }
        //        if indexPath.row > 8 {
        //             resuseIdentifier = originalRowsDic[5]!
        //        }
        
        let screenSortLinesDetail = salesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        
        resuseIdentifier = screenSortLinesDetail.PrototypeCellID
        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as! SaleDetailTableViewCell
        
        if resuseIdentifier == "SalesTypecell" {
            
            cell.lblSalesType.text = salesTransactionHeader.SalesType
            
            if operationType != "Create"{
                cell.SalesTypeButton.isEnabled = false
            }
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "CustomerCell" {
            
            cell.lblCustomerName.text = customer.CustomerName
            
            if operationType != "Create" {
                
                cell.CustomerButton.isEnabled = false
            }
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            // lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "DueDateCell" {
            
            if salesTransactionHeader.DueDate != nil {
                
                cell.lblDueDate.text = salesTransactionHeader.DueDate!.formatted
            }else {
                print("dueDateOption: \(customer.DefaultDueDateOption) ========= dueDate: \(customer.DefaultDueDate)")
                if customer.DefaultDueDateOption == DueDateType.ofTheFollowingMonth.rawValue {
                    
                    let dueDate = ofTheFollowingMonth(days: customer.DefaultDueDate, createDate: salesTransactionHeader.CreateTime)
                    cell.lblDueDate.text = dueDate?.formatted
                    
                }else if customer.DefaultDueDateOption == DueDateType.daysAfterTheInvoiceDate.rawValue {
                    
                    let dueDate = daysAfterTheInvoiceDate(days: customer.DefaultDueDate, transactionDate: salesTransactionHeader.TransactionDate)
                    cell.lblDueDate.text = dueDate.formatted
                    
                }else if customer.DefaultDueDateOption == DueDateType.daysAfterTheEndOfTheInvoiceMonth.rawValue {
                    
                    let dueDate = daysAfterTheEndOfTheInvoiceMonth(days: customer.DefaultDueDate, transactionDate: salesTransactionHeader.TransactionDate)
                    cell.lblDueDate.text = dueDate?.formatted
                    
                }else if customer.DefaultDueDateOption == DueDateType.ofTheCurrentMonth.rawValue {
                    
                    let dueDate = ofTheCurrentMonth(days: customer.DefaultDueDate, transactionDate: salesTransactionHeader.TransactionDate)
                    cell.lblDueDate.text = dueDate?.formatted
                }
            }
        }
        
        if resuseIdentifier == "AddanItemCell" {
            
            if salesDetailScreenLinesDic[indexPath.row].isAdded == true {
                
                
                let image = UIImage(named: "Minus-25") as UIImage?
                
                cell.AddDeleteButton.setImage(image, for: .normal)
                cell.LineDescription.text = salesDetailScreenLinesDic[indexPath.row].LineDescription
                
            }
            else {
                
                let image = UIImage(named: "plus") as UIImage?
                
                
                
                // let image = UIImage(named: "name") as UIImage?
                // cell.AddDeleteButton = UIButton(type: .System) as UIButton
                
                
                cell.AddDeleteButton.setImage(image, for: .normal)
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
                        
                        let salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                        
                        subTotalAmount = subTotalAmount + (salesTransactionsDetailView?.AmountWithoutTax)!
                    }
                }
            }
            
            
            cell.lblSubTotalAmount.text =  String(format: "%.2f", subTotalAmount)
            
            salesTransactionHeader.SubTotal = subTotalAmount
            
        }
        if resuseIdentifier == "TotalCell" {
            
            cell.lblTotalAmountLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
            cell.lblTotalAmount.font = UIFont.boldSystemFont(ofSize: 17.0)
            
            var totalAmount: Double = 0
            for i in 0 ..< salesDetailScreenLinesDic.count
            {
                if salesDetailScreenLinesDic[i].isAdded == true
                {
                    if salesDetailScreenLinesDic[i].salesTransactionsDetailView != nil {
                        
                        let salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                        
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
                
                cell.AddRemoveImageButton.setImage(UIImage(named: "Minus-25.png"), for: UIControl.State.normal)
                cell.lblAddImageLabel.text = "Has a linked image!"
            }
            else{
                cell.AddRemoveImageButton.setImage(UIImage(named: "plus.png"), for: UIControl.State.normal)
                cell.lblAddImageLabel.text = "Add an image"
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
                cell.lblSendEmail.isHidden = true
                cell.SendEmailButton.isEnabled = false
                cell.SendEmailButton.isHidden = true
            }
            else {
                cell.lblSendEmail.isHidden = false
                cell.SendEmailButton.isEnabled = true
                cell.SendEmailButton.isHidden = false
                
            }
            
        }
        
        return cell
        
        
        // Configure the cell...
       // print("indexPath" + indexPath.row.description)
        
        //return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    let row = indexPath.row //2
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected Row" + indexPath.row.description)
        let screenSortLinesDetail = salesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        print("screenSortLinesDetail.PrototypeCellID" + screenSortLinesDetail.PrototypeCellID)
        if screenSortLinesDetail.PrototypeCellID == "SalesTypecell" && operationType == "Create" {
            
            performSegue(withIdentifier: "showPickerView", sender: "SalesTypecell")
            
            
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
            
            
            self.performSegue(withIdentifier: "showContactSearch", sender: "CustomerCell")
            
        }
        if screenSortLinesDetail.PrototypeCellID == "DueDateCell" {
            
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegue(withIdentifier: "showDueDate", sender: "DueDateCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController(title: "Information", message: "A Customer must be seleted!", viewController: self)
            }
            
        }
        
        
        
        if screenSortLinesDetail.PrototypeCellID == "AddanImageCell" {
            
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegue(withIdentifier: "showPhoto", sender: "AddanImageCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController(title: "Information", message: "A Customer must be seleted!", viewController: self)
            }
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "AddanItemCell" {
            
            if salesTransactionHeader.CustomerID.length != 0 {
                addItemRowIndex = indexPath.row
                performSegue(withIdentifier: "showItemDetail", sender: "AddanItemCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController(title: "Information", message: "A Customer must be seleted!", viewController: self)
            }
            
            
            
        }
        
        
        if screenSortLinesDetail.PrototypeCellID == "TransactionDateCell" {
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegue(withIdentifier: "showTransactionDate", sender: "TransactionDateCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController(title: "Information", message: "A Customer must be seleted!", viewController: self)
            }
            
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "MemoCell" {
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegue(withIdentifier: "showMemo", sender: "MemoCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController(title: "Information", message: "A Customer must be seleted!", viewController: self)
            }
            
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "SendEmailCell" {
            
            if salesTransactionHeader.CustomerID.length != 0 {
                performSegue(withIdentifier: "showSendEmail", sender: "SendEmailCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController(title: "Information", message: "A Customer must be seleted!", viewController: self)
            }
        }
        let index = addItemsDic.count
        addItemsDic[index] = "One more Item"
        // let section = indexPath.section//3
        //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //        self.saleDetailTableView.reloadData()
        //            })
        //        let order = menuItems.items[section][row] + " " + menuItems.sections[section] //4
        // navigationItem.title = order
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if salesDetailScreenLinesDic[indexPath.row].isAdded == true {
            return true
        }
       else if salesDetailScreenLinesDic[indexPath.row].PrototypeCellID == "AddanImageCell"
        {
            if attachedimage != nil {
                
                return  true
            } else {
                return false
            }
        }else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            if salesDetailScreenLinesDic[indexPath.row].isAdded == true
            {
                
                print("indexPath.row delete" + indexPath.row.description)
                salesDetailScreenLinesDic.remove(at: indexPath.row)
                
                
                for i in 0 ..< salesDetailScreenLinesDic.count
                {
                    print("salesDetailScreenLinesDic[" + i.description + "].ID" + salesDetailScreenLinesDic[i].ID.description)
                    
                    print("salesDetailScreenLinesDic[" + i.description  + "].isAdded" + salesDetailScreenLinesDic[i].isAdded.description)
                    
                    print("salesDetailScreenLinesDic[" + i.description  + "].PrototypeCellID" +
                        salesDetailScreenLinesDic[i].PrototypeCellID)
                    
                    print("salesDetailScreenLinesDic[i].LineDescription"  + salesDetailScreenLinesDic[i].LineDescription)
                    
                }
               DispatchQueue.main.async {
                    self.saleDetailTableView.reloadData()
                    
                }
                
                
                
            }
            else if salesDetailScreenLinesDic[indexPath.row].PrototypeCellID == "AddanImageCell"
            {
                if attachedimage != nil {
                    
                   attachedimage = nil
                }
                DispatchQueue.main.async {
                    self.saleDetailTableView.reloadData()
                    
                }
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if sender is String {
            
            let fromCell = sender as! String
            //        if let fromCell = sender as? String {
            
            
            
            
            if fromCell == "SalesTypecell"
            {
                let pickerViewController = segue.destination as! PickerViewViewController
                pickerViewController.fromCell = "SalesTypecell"
                
                pickerViewController.delegate = self
            }
            if fromCell == "CustomerCell"
            {
                
                let contactSearchViewController = segue.destination as! CustomerSearchViewController
                contactSearchViewController.fromCell = "CustomerCell"
                contactSearchViewController.delegate = self
                contactSearchViewController.hasAddedItemLine = hasAddedItemLine
                
            }
            
            if fromCell == "DueDateCell"
            {
                
                let datePickerViewController = segue.destination as! DatePickerViewController
                datePickerViewController.fromCell = "DueDateCell"
                datePickerViewController.delegate = self
                
            }
            
            if fromCell == "AddanItemCell"
            {
                let saleDetailDataLineViewController = segue.destination as! SaleDetailDataLineViewController
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
                let addImageViewController = segue.destination as! AddImageViewController
                addImageViewController.fromCell = "AddanImageCell"
                
                if attachedimage != nil
                {
                    addImageViewController.attachedImage = attachedimage
                }
                addImageViewController.delegate = self
            }
            
            if fromCell == "TransactionDateCell"
            {
                
                let datePickerViewController = segue.destination as! DatePickerViewController
                datePickerViewController.fromCell = "TransactionDateCell"
                datePickerViewController.delegate = self
                
            }
            
            if fromCell == "MemoCell"
            {
                
                let saleDetailMemoViewController = segue.destination as! SaleDetailMemoViewController
                saleDetailMemoViewController.fromCell = "MemoCell"
                
                saleDetailMemoViewController.delegate = self
                
                
                saleDetailMemoViewController.textValue = salesTransactionHeader.Memo
                
                
            }
            
            if fromCell == "SendEmailCell"
            {
                       let sendEmailViewController = segue.destination as! SendEmailViewController
                
                sendEmailViewController.salesTransactionHeader = salesTransactionHeader
                sendEmailViewController.customer = customer
                
            }
        }
        
    }
    
    @IBAction func SaveButtonClick(sender: AnyObject) {
        
        if validateQuantityValue()&&validateDate()&&validateIfSaleDetailIsNotEmpty()
        {
            Q6ActivityIndicatorView.isHidden = false
            Q6ActivityIndicatorView.startAnimating()
            
            salesTransactionHeader.TaxTotal = salesTransactionHeader.TotalAmount - salesTransactionHeader.SubTotal
            
            
            var dicData=[String:AnyObject]()
            
            
            let q6DBLib = Q6DBLib()
            let q6CommonLib = Q6CommonLib(myObject: self)
            var userInfos = q6DBLib.getUserInfos()
            
            let LoginDetail = InternalUserLoginParameter()
            
            LoginDetail.LoginUserName = userInfos["LoginEmail"]!
            LoginDetail.Password = userInfos["PassWord"]!
            LoginDetail.ClientIP = Q6CommonLib.getIPAddresses()
            LoginDetail.WebApiTOKEN = Q6CommonLib.getQ6WebAPIToken()
            
            //var NeedValidate = true
            
            
            var LoginDetailDicData = [String:AnyObject]()
            
            LoginDetailDicData["Email"] = userInfos["LoginEmail"]! as AnyObject?
            LoginDetailDicData["Password"] = userInfos["PassWord"]! as AnyObject?
            LoginDetailDicData["CompanyID"] = userInfos["CompanyID"]! as AnyObject?
            LoginDetailDicData["WebApiTOKEN"] = Q6CommonLib.getQ6WebAPIToken() as AnyObject?
            
            dicData["LoginDetail"] = LoginDetailDicData as AnyObject?
            
              if attachedimage != nil {
            salesTransactionHeader.HasLinkedDoc = true
           
                let UploadedDocuments = getImageFileDataDic(image: attachedimage!)
                
                dicData["UploadedDocuments"] = UploadedDocuments as AnyObject?
            }
            else{
                dicData["UploadedDocuments"] = nil
            }
            
            
            
            let salesTransactionsDetailDataDic = convertsalesTransactionsDetailDataTOArray()
            
            let salesTransactionsHeaderDic = convertsalesTransactionsHeaderToArray()
            
            dicData["SalesTransactionsDetail"] = salesTransactionsDetailDataDic as AnyObject?
            dicData["SalesTransactionsHeader"] = salesTransactionsHeaderDic as AnyObject?
            dicData["RecurringTemplateList"] = nil
            
            dicData["NeedValidate"] = false as AnyObject?
            var salesTransactionsParameter = [String: AnyObject]()
            
            salesTransactionsParameter["SalesTransactionsParameter"] = dicData as AnyObject?
            
            isPreLoad = false
            
            if operationType == "Create" {
                q6CommonLib.Q6IosClientPostAPI(ModeName: "Sale",ActionName: "AddSale", dicData:dicData)
            } else if operationType == "Edit"{
                q6CommonLib.Q6IosClientPostAPI(ModeName: "Sale",ActionName: "EditSale", dicData:dicData)
            }
            
            btnSaveButton.isEnabled = false
            btnCancelButton.isEnabled = false
            
        }
    }
    
    func getImageFileDataDic(image: UIImage) -> [String: AnyObject]
    {
        
        let FileName = "AttachedPhoneImage"
        //
        let imgData: NSData = NSData(data: (image).jpegData(compressionQuality: 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        let FileSize: Int = imgData.length
        print("File Size" + FileSize.description)
        let HasLinkedTransaction = false
      
        let TransactionType:String? = nil
        let UploadedBy:String? = nil 
        
        let UploadedDate = NSDate().description
        let UploadedDocumentsID = "{00000000-0000-0000-0000-000000000000}"
        var i = CGFloat()
        if  FileSize > 2000000 {
            
            i = CGFloat (2000000 / FileSize)
            
        }
        else {
            i = 1
        }
        let imageData = image.jpegData(compressionQuality: i)
        let File = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        var dicData = [String: AnyObject]()
        
        dicData["File"] = File as AnyObject?
        dicData["FileName"] = FileName as AnyObject?
        dicData["FileSize"] = FileSize as AnyObject?
        dicData["HasLinkedTransaction"] = HasLinkedTransaction as AnyObject?
        dicData["TransactionType"] = TransactionType as AnyObject?
        dicData["UploadedBy"] = UploadedBy as AnyObject?
        dicData["UploadedDate"] = UploadedDate as AnyObject?
        dicData["UploadedDocumentsID"] = UploadedDocumentsID as AnyObject?
        
        return dicData
        //  print("size of image in KB: %f ", imageSize / 1024)
    }
    func convertsalesTransactionsHeaderToArray() -> [String: AnyObject]
    {
        var dicData = [String: AnyObject]()
        
        let SalesTransactionsHeaderID  = salesTransactionHeader.SalesTransactionsHeaderID
        
        if operationType == "Create" {
            dicData["SalesTransactionsHeaderID"] = "{00000000-0000-0000-0000-000000000000}" as AnyObject?
        }
        else {
            dicData["SalesTransactionsHeaderID"] = SalesTransactionsHeaderID as AnyObject?
        }
        dicData["ReferenceNo"] = salesTransactionHeader.ReferenceNo as AnyObject?
        
        dicData["SalesType"] = salesTransactionHeader.SalesType as AnyObject?
        dicData["SalesStatus"] = salesTransactionHeader.SalesStatus as AnyObject?
        dicData["TransactionDate"] = salesTransactionHeader.TransactionDate.description as AnyObject?
        
        print("salesTransactionHeader.TransactionDate.description" + salesTransactionHeader.TransactionDate.description)
        dicData["CreateTime"] = salesTransactionHeader.CreateTime.description as AnyObject?
        
        //        var LastModifiedTime = NSDate()
        //        let dateFormatter = NSDateFormatter()
        //        //dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        //       // dateFormatter.timeStyle =  NSDateFormatterStyle.LongStyle
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        //       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //       var strLastModifiedTime = dateFormatter.stringFromDate(LastModifiedTime)
        //        print("strLastModifiedTime" + strLastModifiedTime)
        
        if operationType == "Create" {
            dicData["LastModifiedTime"] = salesTransactionHeader.CreateTime.description as AnyObject?
        }
        else{
            dicData["LastModifiedTime"] = salesTransactionHeader.LastModifiedTime as AnyObject?
        }
        
        dicData["CustomerID"] = salesTransactionHeader.CustomerID as AnyObject?
        dicData["ShipToAddress"] = salesTransactionHeader.ShipToAddress as AnyObject?
//        dicData["CustomerInv"] = salesTransactionHeader.CustomerInv
        dicData["Memo"] = salesTransactionHeader.Memo as AnyObject?
        
        dicData["ClosedDate"] = salesTransactionHeader.ClosedDate?.description as AnyObject?
        dicData["SubTotal"] = salesTransactionHeader.SubTotal as AnyObject?
        dicData["TaxTotal"] = salesTransactionHeader.TaxTotal as AnyObject?
        dicData["TotalAmount"] = salesTransactionHeader.TotalAmount as AnyObject?
        dicData["DueDate"] = salesTransactionHeader.DueDate?.description as AnyObject?
        dicData["TaxInclusive"] = salesTransactionHeader.TaxInclusive as AnyObject?
        dicData["IsDeleted"] = salesTransactionHeader.IsDeleted as AnyObject?
        dicData["IsCreatedByRecurring"] = salesTransactionHeader.IsCreatedByRecurring as AnyObject?
        dicData["RecurringTemplateID"] = salesTransactionHeader.RecurringTemplateID as AnyObject?
        dicData["HasLinkedDoc"] = salesTransactionHeader.HasLinkedDoc as AnyObject?
        dicData["CustomerPurchaseNO"] = salesTransactionHeader.CustomerPurchaseNO as AnyObject?
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
                
                let SalesTransactionsDetailID = salesTransactionsDetailData[i].SalesTransactionsDetailID
                if operationType == "Create"{
                    data["SalesTransactionsDetailID"] = "{00000000-0000-0000-0000-000000000000}" as AnyObject?
                }
                else {
                    data["SalesTransactionsDetailID"] = SalesTransactionsDetailID as AnyObject?
                }
                
                
                
                let SalesTransactionsHeaderID = salesTransactionsDetailData[i].SalesTransactionsHeaderID
                
                if operationType == "Create" {
                    data["SalesTransactionsHeaderID"] = "{00000000-0000-0000-0000-000000000000}" as AnyObject?
                }
                else {
                    data["SalesTransactionsHeaderID"] = SalesTransactionsHeaderID as AnyObject?
                }
                data["Quantity"] = salesTransactionsDetailData[i].Quantity as AnyObject?
                
                data["InventoryID"] = salesTransactionsDetailData[i].InventoryID as AnyObject?
                data["AccountID"] = salesTransactionsDetailData[i].AccountID as AnyObject?
                data["TaxCodeID"] = salesTransactionsDetailData[i].TaxCodeID as AnyObject?
                data["Description"] = salesTransactionsDetailData[i].Description as AnyObject?
                
                data["UnitPrice"] = salesTransactionsDetailData[i].UnitPrice as AnyObject?
                data["Discount"] = salesTransactionsDetailData[i].Discount as AnyObject?
                data["Amount"] = salesTransactionsDetailData[i].Amount as AnyObject?
                
                data["IsDeleted"] = salesTransactionsDetailData[i].IsDeleted as AnyObject?
                data["SortNo"] = salesTransactionsDetailData[i].SortNo as AnyObject?
                
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
            Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "You need to add at least one data line before you save sale transaction !", viewController: self)
            
            IsNotEmpty = false
        }
        
        return IsNotEmpty
        
    }
    func validateDate()-> Bool
    {
        var isValid = true
        if salesTransactionHeader.SalesType == "Invoice"
        {
            if salesTransactionHeader.DueDate == nil
            {
                
                Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "Due Date can not be empty if sale type is Invoice!", viewController: self)
                isValid = false
            }
        }
        
        if salesTransactionHeader.DueDate != nil {
            
            let DueDate = salesTransactionHeader.DueDate
            let TransactionDate = salesTransactionHeader.TransactionDate
            
            let isLaterOrEqual = (DueDate?.isLaterOrEqualThanDate(dateToCompare: TransactionDate))! as Bool
            
            if isLaterOrEqual == false {
                Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "Due Date can not be later than TransactionDate!", viewController: self)
                isValid = false
            }
        }
        return isValid
    }
    func validateQuantityValue() -> Bool
    {
        var isValid = true
        if salesTransactionHeader.SalesType == "CreditNote"
        {
            for i in 0..<salesDetailScreenLinesDic.count
            {
                let salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                
                if salesTransactionsDetailView != nil && salesDetailScreenLinesDic[i].isAdded == true
                {
                    if  salesTransactionsDetailView!.Quantity > 0
                    {
                        Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "you can not input positive amount at quantity field when sale type is CREDIT NOTE!", viewController: self)
                        isValid = false
                        
                    }
                }
            }
            
        }
        else {
            for i in 0..<salesDetailScreenLinesDic.count
            {
                let salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
                
                if salesTransactionsDetailView != nil && salesDetailScreenLinesDic[i].isAdded == true
                {
                    if  salesTransactionsDetailView!.Quantity < 0
                    {
                        Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "you can not input negative amount at quantity field when sale type is QUOTE,ORDER ,INVOICE!", viewController: self)
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
            let salesTransactionsDetailView = salesDetailScreenLinesDic[i].salesTransactionsDetailView
            if salesTransactionsDetailView != nil && salesDetailScreenLinesDic[i].isAdded == true
            {
                let salesTransactionsDetail = SalesTransactionsDetail()
                
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
            let salesTransactionDetail = SalesTransactionsDetail()
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
            
            let screenSortLinesDetail = ScreenSortLinesDetail()
            screenSortLinesDetail.ID = 3 + i
            screenSortLinesDetail.isAdded = true
            screenSortLinesDetail.LineDescription = salesTransactionsDetailList[i].InventoryName + salesTransactionsDetailList[i].AccountNameWithAccountNo
            screenSortLinesDetail.salesTransactionsDetailView = salesTransactionsDetailList[i]
            screenSortLinesDetail.PrototypeCellID = "AddanItemCell"
            
            salesDetailScreenLinesDic.insert(screenSortLinesDetail, at: screenSortLinesDetail.ID)
            
            
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
       _ = navigationController?.popToRootViewController(animated: true)
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
        
        var indexPath:Int?
        
        
        for index in 0 ..< salesDetailScreenLinesDic.count {
            let screenSortLinesDetail = salesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
            if screenSortLinesDetail.isAdded == true {
                indexPath = index
            }
        }
        return indexPath
    }
    
    func ValidteWhetherHasAddedLinesInsalesDetailScreenLinesDic() -> Bool {
        
        for index in 0 ..< salesDetailScreenLinesDic.count {
            let screenSortLinesDetail = salesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
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
                
                DispatchQueue.main.async {
                    self.saleDetailTableView.reloadData()
                    
                }
                
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
                print("defaultDueDate: \(customer.DefaultDueDate) === defaultDueDateOption: \(customer.DefaultDueDateOption)")
                
                print("salesTransactionHeader.CustomerID" + salesTransactionHeader.CustomerID)
                
                DispatchQueue.main.async {
                    self.saleDetailTableView.reloadData()
                }
            }
        }
        
        
    }
    
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
    {
        if fromView == "DatePickerViewController" {
            if forCell == "DueDateCell" {
                
                salesTransactionHeader.DueDate = Date
                
                DispatchQueue.main.async {
                    self.saleDetailTableView.reloadData()
                    
                }
                
            }
            
            if forCell == "TransactionDateCell" {
                
                salesTransactionHeader.TransactionDate = Date
                
                DispatchQueue.main.async {
                    self.saleDetailTableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    
    func sendGoBackFromSaleDetailDataLineView(fromView:String,forCell:String,salesTransactionsDetailView: SalesTransactionsDetailView){
        
        if salesDetailScreenLinesDic[addItemRowIndex].isAdded == false{
            
            let screenSortLinesDetail = ScreenSortLinesDetail()
            screenSortLinesDetail.isAdded = true
            screenSortLinesDetail.ID = addItemRowIndex
            screenSortLinesDetail.LineDescription = salesTransactionsDetailView.InventoryName + " " + salesTransactionsDetailView.AccountNameWithAccountNo
            screenSortLinesDetail.PrototypeCellID = "AddanItemCell"
            screenSortLinesDetail.salesTransactionsDetailView = salesTransactionsDetailView
            salesDetailScreenLinesDic.insert(screenSortLinesDetail, at: addItemRowIndex)
            
      DispatchQueue.main.async {
                self.saleDetailTableView.reloadData()
                
            }
        }
        else{
            salesDetailScreenLinesDic[addItemRowIndex].LineDescription = salesTransactionsDetailView.InventoryName + " " + salesTransactionsDetailView.AccountNameWithAccountNo
            salesDetailScreenLinesDic[addItemRowIndex].salesTransactionsDetailView = salesTransactionsDetailView
            DispatchQueue.main.async {
                self.saleDetailTableView.reloadData()
                
            }
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
                
                
                
               DispatchQueue.main.async {
                    self.saleDetailTableView.reloadData()
                    
                }
                
            }
        }
    }
    
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        if operationType == "Edit" && isPreLoad == true {
            
            var postDicData :[String:AnyObject]
            
            do {
                //                if dataRequestSource == "Search" {
                //                    CustomerData.removeAll()
                //                    selectedSuplier = nil
                //                }
                postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
                
                let returnSalesTransactionHeaderData = postDicData["SalesTransactionsHeader"]  as? [String:AnyObject]
                
                if returnSalesTransactionHeaderData != nil {
                    
                    let salesTransactionsHeaderView =   initialSalesTransactionsHeaderView(returnsalesTransactionHeaderData: returnSalesTransactionHeaderData!)
                    
                    copyFromSalesTransactionsHeaderViewToSalesTransactionsHeader(salesTransactionsHeaderView: salesTransactionsHeaderView)
                    
                    
                }
                
                let returnSalesTransactionsDetailListData = postDicData["SalesTransactionsDetailList"]  as? [[String:AnyObject]]
                
                
                if returnSalesTransactionsDetailListData != nil {
                    
                    let salesTransactionsDetailView =    initialSalesTransactionsDetailListView(returnSalesTransactionDetailListData: returnSalesTransactionsDetailListData!)
                    
                    copyFromSalesTransactionDetailViewToSalesTransactionDetailForEdit(salesTransactionsDetailList: salesTransactionsDetailView)
                    
                    
                    DispatchQueue.main.async {
                        self.saleDetailTableView.reloadData()
                        //                        self.Q6ActivityIndicatorView.hidesWhenStopped = true
                        //                        self.Q6ActivityIndicatorView.stopAnimating()
                        //                        self.ContactSearchBox.resignFirstResponder()
                        
                        self.saleDetailTableView.isHidden = false
                        self.Q6ActivityIndicatorView.hidesWhenStopped = true
                        self.Q6ActivityIndicatorView.stopAnimating()
                    }
                    
                }
            } catch  {
                print("error parsing response from POST on /posts")
                
                return "" as AnyObject
            }
            
            
        }
        
        if isPreLoad == true && operationType == "Create" {
            
            
            
            var postDicData :[String:AnyObject]
            var IsLoginSuccessed : Bool
            do {
                postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
                
                
                IsLoginSuccessed = (postDicData["IsSuccessed"] as! NSString).boolValue
                
                
                if IsLoginSuccessed == true {
                    
                 //   var q6CommonLib = Q6CommonLib()
                    var returnValue = postDicData["ReturnValue"]! as! Dictionary<String, AnyObject>
                    //
                    let shippingAddress = ShippingAddress()
                    let Address = returnValue["ShippingAddress"] as? String
                    
                    
                    if Address != nil {
                        shippingAddress.ShippingAddress = Address!
                    }
                    let  ShippingAddressLine2 = returnValue["ShippingAddressLine2"] as? String
                    
                    if ShippingAddressLine2 != nil {
                        shippingAddress.ShippingAddressLine2 = ShippingAddressLine2!
                    }
                    
                    let  ShippingCity = returnValue["ShippingCity"] as? String
                    
                    if ShippingCity != nil {
                        shippingAddress.ShippingCity = ShippingCity!
                    }
                    let ShippingCountry = returnValue["ShippingCountry"] as? String
                    
                    if ShippingCountry != nil {
                        shippingAddress.ShippingCountry = ShippingCountry!
                    }
                    
                    let ShippingPostalCode = returnValue["ShippingPostalCode"] as? String
                    
                    if ShippingPostalCode != nil {
                        shippingAddress.ShippingPostalCode = ShippingPostalCode!
                    }
                    
                    let ShippingState = returnValue["ShippingState"] as? String
                    
                    if ShippingState != nil {
                        shippingAddress.ShippingState = ShippingState!
                    }
                    
                    let RealCompanyName = returnValue["RealCompanyName"] as? String
                    
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
                
                return "" as AnyObject
            }
        }
        
        if isPreLoad == false && (operationType == "Create"||operationType == "Edit") {
            
            var postDicData :[String:AnyObject]
            var IsSuccessed : Bool?
            var Message: String?
            do {
                postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
                
                IsSuccessed = postDicData["IsSuccessed"] as? Bool
                Message = postDicData["Message"] as? String
                if IsSuccessed != nil {
                    IsSuccessed = postDicData["IsSuccessed"] as? Bool
                }
                ////                else{
                //                var message = postDicData["Message"] as! String
                //                print("Message" + message)
                ////                }
                if IsSuccessed == true {
                    
                    _ = navigationController
                    // Q6CommonLib.q6UIAlertPopupControllerThenGoBack("Information message", message: "Save Successfully!", viewController: self,timeArrange:3,navigationController: nav!)
                    DispatchQueue.main.async {

                        let alert = UIAlertController(title: "Information message", message: "Save Successfully!", preferredStyle: UIAlertController.Style.alert)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    
                    
                    
//                    let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//                                                  Int64(3 * Double(NSEC_PER_SEC)))
//                    let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
//                                                   Int64(4 * Double(NSEC_PER_SEC)))
//                    dispatch_after(delayTime, dispatch_get_main_queue()) {
//                        self.dismissViewControllerAnimated(true, completion: nil);
//                        // self.navigationController!.popViewControllerAnimated(true)
//                        // self.navigationController?.popToRootViewControllerAnimated(true)
//                    }
//                    dispatch_after(delayTime2, dispatch_get_main_queue()) {
//                        // self.dismissViewControllerAnimated(true, completion: nil);
//                        
//                        self.delegate2?.sendGoBackSaleDetailView("SaleDetailViewController", fromButton: "Save")
//                        self.navigationController!.popViewControllerAnimated(true)
//                        // self.navigationController?.popToRootViewControllerAnimated(true)
//                    }
//                    
                    
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
                        self.delegate2?.sendGoBackSaleDetailView(fromView: "SaleDetailViewController", fromButton: "Save")
                        self.navigationController!.popViewController(animated: true)
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
                    
                    var txtMessage = "Save Fail! \n"
                    if Message != nil {
                        
                        txtMessage = txtMessage + Message!
                    }
                   
                    btnSaveButton.isEnabled = true
                    btnCancelButton.isEnabled = true
                    Q6ActivityIndicatorView.hidesWhenStopped = true
                    Q6ActivityIndicatorView.isHidden = true
                    Q6ActivityIndicatorView.stopAnimating()
                    
                    
                    Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: txtMessage, viewController: self, timeArrange:2)
                   
                }
                
            } catch  {
                print("error parsing response from POST on /posts")
                btnSaveButton.isEnabled = false
                btnCancelButton.isEnabled = false
                return "" as AnyObject
            }
            
            
        }
        
        //
        return "" as AnyObject
    }
    
    func initialSalesTransactionsDetailListView(returnSalesTransactionDetailListData : [[String: AnyObject]]) ->[SalesTransactionsDetailView]
    {
        var salesTransactionsDetailViewList = [SalesTransactionsDetailView]()
        
        for i in 0..<returnSalesTransactionDetailListData.count
        {
            let salesTransactionsDetailView = SalesTransactionsDetailView()
            
            salesTransactionsDetailView.AccountID = returnSalesTransactionDetailListData[i]["AccountID"] as? String
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
                
                let taxCodeRate = salesTransactionsDetailView.TaxCodeRate
                
                let amount = salesTransactionsDetailView.Amount
                
                salesTransactionsDetailView.AmountWithoutTax = amount / (1 + taxCodeRate!/100)
                
                
            }
            
            salesTransactionsDetailViewList.append(salesTransactionsDetailView)
            
            
        }
        
        return salesTransactionsDetailViewList
    }
    func initialSalesTransactionsHeaderView(returnsalesTransactionHeaderData : [String: AnyObject]!) -> SalesTransactionsHeaderView
    {
        
        let salesTransactionsHeaderView = SalesTransactionsHeaderView()
        salesTransactionsHeaderView.ClosedDate = returnsalesTransactionHeaderData!["ClosedDate"] as? NSDate
        
        
        
        let DueDate = returnsalesTransactionHeaderData!["DueDate"] as? String
        
        if DueDate != nil {
            print("DueDate" + DueDate!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            salesTransactionsHeaderView.DueDate = dateFormatter.date(from: DueDate!) as NSDate?
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
        
        
        
        let LastModifiedTime = returnsalesTransactionHeaderData!["LastModifiedTime"] as! String
        
        
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
        
        
        
        
        let TransactionDate  = returnsalesTransactionHeaderData!["TransactionDate"] as! String
        
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        salesTransactionsHeaderView.TransactionDate = dateFormatter2.date(from: TransactionDate)! as NSDate
        
        salesTransactionsHeaderView.UploadedDocumentsID = returnsalesTransactionHeaderData!["UploadedDocumentsID"] as? String
        
        if salesTransactionsHeaderView.UploadedDocumentsID != nil {
            
            let imageDataStr = salesTransactionsHeaderView.LinkDocumentFile
            
            
            let imageData = NSData(base64Encoded: imageDataStr!, options: NSData.Base64DecodingOptions(rawValue: 0))
            attachedimage = UIImage(data: imageData! as Data)
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
        
      DispatchQueue.main.async {
            self.navigationBar.topItem?.title = self.salesTransactionHeader.ReferenceNo
        }
        
        salesTransactionHeader.ShipToAddress = salesTransactionsHeaderView.ShipToAddress
        salesTransactionHeader.SubTotal = salesTransactionsHeaderView.SubTotal
        salesTransactionHeader.CustomerID = salesTransactionsHeaderView.CustomerID
        
        print("salesTransactionHeader.CustomerID" + salesTransactionHeader.CustomerID)
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
        
 DispatchQueue.main.async {
            self.saleDetailTableView.reloadData()
            
        }
        
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
    ////            IsLoginSuccessed = (postDicData["IsSuccessed"] as! NSString).boolValue
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

