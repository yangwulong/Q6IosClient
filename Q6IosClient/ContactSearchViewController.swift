//
//  ContactSearchViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 15/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactSearchViewController: UIViewController , Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate,Q6GoBackFromViewTwo{
    @IBOutlet weak var ContactSegmentedControl: UISegmentedControl!

    @IBOutlet weak var ContactSearchBox: UISearchBar!


  
    
    var pageIndex: Int = 1
    var pageSize: Int = 20
    var searchText: String = ""
    var dataRequestSource = ""
    var attachedURL = String()
    
    var selectedContact = Contact?()
    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var ContactTableView: UITableView!
  
    var contactData = [Contact]()
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    override func viewWillAppear(animated: Bool) {
    
//        ContactSearchBox.text = ""
//        Q6ActivityIndicatorView.startAnimating()
//        let q6CommonLib = Q6CommonLib(myObject: self)
//        
//        setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
//        
//        if ContactSegmentedControl.selectedSegmentIndex == 0 {
//            
//            
//            q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
//        }
//        else {
//            q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
//        }
        
    }
    override func viewDidLoad() {
    super.viewDidLoad()
    setControlAppear()
    ContactSearchBox.delegate = self
    ContactTableView.delegate = self
    ContactTableView.dataSource = self

        
        ContactSearchBox.text = ""
        Q6ActivityIndicatorView.startAnimating()
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        
        if ContactSegmentedControl.selectedSegmentIndex == 0 {
            
            
            q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        else {
            q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        }
    
    // Do any additional setup after loading the view.
    }
    func setControlAppear()
    {
    
    ContactSearchBox.layer.cornerRadius = 2;
    ContactSearchBox.layer.borderWidth = 0.1;
    ContactSearchBox.layer.borderColor = UIColor.blackColor().CGColor
        
        if ContactSegmentedControl.selectedSegmentIndex == 0 {
            ContactSearchBox.placeholder = "Supplier Name"
            
        }
        else {
            ContactSearchBox.placeholder = "Customer Name"
        }
    }
    
    
    @IBAction func ContactSegmentedControlAction(sender: AnyObject) {
        
        Q6ActivityIndicatorView.startAnimating()
       // contactData.removeAll()
        searchText = ""
        let q6CommonLib = Q6CommonLib(myObject: self)
        pageIndex = 1
        dataRequestSource = "Search"
        setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        if ContactSegmentedControl.selectedSegmentIndex == 0 {
            
            ContactSearchBox.placeholder = "Supplier Name"
            
            q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        else {
            ContactSearchBox.placeholder = "Customer Name"
            q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        }

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
    return contactData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let  cell = tableView.dequeueReusableCellWithIdentifier("ContactSearchPrototypeCell", forIndexPath: indexPath) as! ContactSearchViewTableViewCell
    
    cell.lblContactID.hidden = true
    
    
    cell.lblContactName.text =  contactData[indexPath.row].ContactName
    cell.lblContactID.text =  contactData[indexPath.row].ContactID
    
    // Configure the cell...
    
    return cell
    }
    
    func setAttachedURL(SearchText: String , IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
    attachedURL = "&Search=" + SearchText + "&IsLoadInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(pageIndex)
    }
    
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        let selecedSegmentIndex: Int = ContactSegmentedControl.selectedSegmentIndex
    var postDicData :[String:AnyObject]?
    
    do {
    if dataRequestSource == "Search" {
    contactData.removeAll()
    selectedContact = nil
    }
      
    postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]
   
        if postDicData != nil {
        
    var returnData =  [[String : AnyObject]]?()
        
        if selecedSegmentIndex == 0 {
       let tempReturnData = postDicData!["SupplierList"] as? [[String : AnyObject]]
            
            if tempReturnData != nil {
                returnData = tempReturnData
            }
        }
        else {
            let tempReturnData = postDicData!["CustomerList"] as? [[String : AnyObject]]
            if tempReturnData != nil {
                returnData = tempReturnData
            }

        }
   
            if returnData != nil {
    
    for i in 0  ..< returnData!.count {
    
    //
    //                print("no i =" + i.description)
    var dataItem = returnData![i]
    
    let contact = Contact()
        
        if selecedSegmentIndex == 0
        {
            let ContactID = dataItem["SupplierID"] as? String
            
            if ContactID != nil {
                contact.ContactID = ContactID!
            }
            
            let ContactName = dataItem["SupplierName"] as? String
            
            if ContactName != nil {
                contact.ContactName = ContactName!
            }
    //   print("SupplierName" + supplier.SupplierName)
        }
        else
        {
            let ContactID = dataItem["CustomerID"] as? String
            
            if ContactID != nil {
                contact.ContactID = ContactID!
            }
            
            let ContactName = dataItem["CustomerName"] as? String
            
            if ContactName != nil {
                contact.ContactName = ContactName!
            }
        }
    
    
//    supplier.DefaultPurchasesAccountID = dataItem["DefaultPurchasesAccountID"]  as? String
//    
//    
//    supplier.DefaultPurchasesTaxCodeID = dataItem["DefaultPurchasesTaxCodeID"]  as? String
//    
//    supplier.DefaultPurchasesAccountNameWithAccountNo = dataItem["DefaultPurchasesAccountNameWithAccountNo"] as? String
//    
//    supplier.DefaultPurchasesTaxCodeName = dataItem["DefaultPurchasesTaxCodeName"] as! String
//    
//    
//    supplier.DefaultPurchasesTaxCodeRate = dataItem["DefaultPurchasesTaxCodeRate"] as! Double
//    
//    supplier.DefaultPurchasesTaxCodePurpose = dataItem["DefaultPurchasesTaxCodePurpose"] as! String
    
    
    
//    if  supplier.DefaultPurchasesAccountNameWithAccountNo != nil {
//    
//    print(" supplier.DefaultPurchasesAccountNameWithAccountNO" +  supplier.DefaultPurchasesAccountNameWithAccountNo!)
//    
//    }
    contactData.append(contact)
                }
    //
    //                printFields(purchasesTransactionListViewDataItem)
    }
    
 
    
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
    self.ContactTableView.reloadData()
    self.Q6ActivityIndicatorView.hidesWhenStopped = true
    self.Q6ActivityIndicatorView.stopAnimating()
    self.ContactSearchBox.resignFirstResponder()
    
    })
    
    
        }
    } catch  {
    print("error parsing response from POST on /posts")
    
    return ""
    }
    
    return ""
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    print("selected indexpath" + indexPath.row.description)
    let  cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactSearchViewTableViewCell
    
    selectedContact = contactData[indexPath.row]
        
         self.performSegueWithIdentifier("editContact", sender: "ContactSearchPrototypeCell")
    ContactSearchBox.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    print("indexpath" + indexPath.row.description)
    if indexPath.row == pageIndex*(pageSize - 5 )
    {
    let q6CommonLib = Q6CommonLib(myObject: self)
    pageIndex = pageIndex + 1
    setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
    dataRequestSource = ""
        
        if ContactSegmentedControl.selectedSegmentIndex == 0
        {
    q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        else {
           q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        }
    }
    
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
    self.searchText = searchText
    
    if searchText.length == 0 {
    
    
    
    let q6CommonLib = Q6CommonLib(myObject: self)
    
    pageIndex = 1
    contactData.removeAll()
    selectedContact = nil
    
    dataRequestSource = "Search"
    
        
    setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
        
        if ContactSegmentedControl.selectedSegmentIndex == 0 {
            
       
    q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        else {
          q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        }
    
    }
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar)
    {
    let q6CommonLib = Q6CommonLib(myObject: self)
    
    pageIndex = 1
    contactData.removeAll()
    selectedContact = nil
    
    dataRequestSource = "Search"
    setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
        
        if ContactSegmentedControl.selectedSegmentIndex == 0 {
    q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        else {
           q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)  
        }
    
    searchBar.resignFirstResponder()
    
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var ContactType = ""
        
              let contactViewController = segue.destinationViewController as! ContactViewController
        if segue.identifier == "createContact" {
            
            
            if ContactSegmentedControl.selectedSegmentIndex == 0 {
                
                ContactType = "Supplier"
                
            
            }
            else {
                ContactType = "Customer"
            }
            contactViewController.ContactType = ContactType
            contactViewController.OperationType = "Create"
            contactViewController.delegate2 = self
           // contactViewController.ContactID = (selectedContact?.ContactID)!
        }
        
        if segue.identifier == "editContact" {
            
            
            if ContactSegmentedControl.selectedSegmentIndex == 0 {
                
                ContactType = "Supplier"
                
                
            }
            else {
                ContactType = "Customer"
            }
            contactViewController.ContactType = ContactType
            contactViewController.OperationType = "Edit"
            contactViewController.ContactID = (selectedContact?.ContactID)!
            contactViewController.delegate2 = self
        }
    }
    func  sendGoBackFromPurchaseDetailView(fromView : String ,fromButton: String)
    {}
    func  sendGoBackSaleDetailView(fromView : String ,fromButton: String)
    {}
    func  sendGoBackContactDetailView(fromView : String ,fromButton: String)
    {
    
        //ContactSearchBox.text = ""
        searchText = ""
        Q6ActivityIndicatorView.startAnimating()
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        pageIndex = 1
    contactData.removeAll()
        setAttachedURL(searchText, IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        
        if ContactSegmentedControl.selectedSegmentIndex == 0 {
            
            
            q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetSupplierList", attachedURL: attachedURL)
        }
        else {
            q6CommonLib.Q6IosClientGetApi("Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        }
        
    }
    
//    @IBAction func DoneButtonClick(sender: AnyObject) {
//    
//    if selectedContact == nil {
//    
//    Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't select a supplier", viewController: self)
//    }
//    else{
//    
//    self.delegate?.sendGoBackFromSupplierSearchView("SupplierSearchViewController" ,forCell :fromCell,Contact: selectedContact!)
//    //
//    
//    navigationController?.popViewControllerAnimated(true)
//    
//    }
    
    
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
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


