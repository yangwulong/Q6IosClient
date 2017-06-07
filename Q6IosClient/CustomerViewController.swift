//
//  SupplierSearchViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class CustomerSearchViewController: UIViewController , Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{
    
    var pageIndex: Int = 1
    var pageSize: Int = 20
    var searchText: String = ""
    var dataRequestSource = ""
    var attachedURL = String()
    var hasAddedItemLine = false
    var selectedCustomer:Customer?
    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var ContactTableView: UITableView!
    @IBOutlet weak var ContactSearchBox: UISearchBar!
    var customerData = [Customer]()
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    override func viewWillAppear(_ animated: Bool) {
        
        if hasAddedItemLine ==  true
        {
            Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "If changing the customer, Please check the defaults are set correctly!", viewController: self ,timeArrange: 3)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setControlAppear()
        ContactSearchBox.delegate = self
        ContactTableView.delegate = self
        ContactTableView.dataSource = self
        Q6ActivityIndicatorView.startAnimating()
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        
        
        // Do any additional setup after loading the view.
    }
    func setControlAppear()
    {
        
        ContactSearchBox.layer.cornerRadius = 2;
        ContactSearchBox.layer.borderWidth = 0.1;
        ContactSearchBox.layer.borderColor = UIColor.black.cgColor
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
        return customerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "CustomerSearchPrototypeCell", for: indexPath) as! CustomerSearchTableViewCell
        
        cell.lblCustomerID.isHidden = true
        
        
        cell.lblCustomerName.text =  customerData[indexPath.row].CustomerName
        
        cell.lblCustomerID.text =  customerData[indexPath.row].CustomerID
        
        // Configure the cell...
        
        return cell
    }
    
    func setAttachedURL(SearchText: String , IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
        attachedURL = "&Search=" + SearchText + "&IsLoadInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(pageIndex)
    }
    
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                customerData.removeAll()
                selectedCustomer = nil
            }
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["CustomerList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            
            for i in 0  ..< returnData.count {
                
                //
                //                print("no i =" + i.description)
                var dataItem = returnData[i]
                
                let customer = Customer()
                customer.CustomerID = dataItem["CustomerID"] as! String
                
                // print("SupplierID" + supplier.SupplierID)
                
                customer.CustomerName = dataItem["CustomerName"] as! String
                //   print("SupplierName" + supplier.SupplierName)
                
                
                customer.DefaultSalesAccountID = dataItem["DefaultSalesAccountID"]  as? String
                
                
                customer.DefaultSalesTaxCodeID = dataItem["DefaultSalesTaxCodeID"]  as? String
                
                customer.DefaultSalesAccountNameWithAccountNo = dataItem["DefaultSalesAccountNameWithAccountNo"] as? String
                
                customer.DefaultSalesTaxCodeName = dataItem["DefaultSalesTaxCodeName"] as! String
                
                
                customer.DefaultSalesTaxCodeRate = dataItem["DefaultSalesTaxCodeRate"] as! Double
                
                customer.DefaultSalesTaxCodePurpose = dataItem["DefaultSalesTaxCodePurpose"] as! String
                
                
                
                if  customer.DefaultSalesAccountNameWithAccountNo != nil {
                    
                    print(" customer.DefaultSalesAccountNameWithAccountNO" +  customer.DefaultSalesAccountNameWithAccountNo!)
                    
                }
                customerData.append(customer)
                //
                //                printFields(purchasesTransactionListViewDataItem)
            }
            
            print("customer Date Count" + customerData.count.description)
            
            DispatchQueue.main.async {
                self.ContactTableView.reloadData()
                self.Q6ActivityIndicatorView.hidesWhenStopped = true
                self.Q6ActivityIndicatorView.stopAnimating()
                self.ContactSearchBox.resignFirstResponder()
                
            }
            
            
            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return "" as AnyObject
        }
        
        return "" as AnyObject
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected indexpath" + indexPath.row.description)
        _ = tableView.cellForRow(at: indexPath as IndexPath) as! CustomerSearchTableViewCell
        
        selectedCustomer = customerData[indexPath.row]
        ContactSearchBox.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexpath" + indexPath.row.description)
        if indexPath.row == pageIndex*(pageSize - 5 )
        {
            let q6CommonLib = Q6CommonLib(myObject: self)
            pageIndex = pageIndex + 1
            setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
            dataRequestSource = ""
            q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            pageIndex = 1
            customerData.removeAll()
            selectedCustomer = nil
            
            dataRequestSource = "Search"
            
            setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
            q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
            
        }
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        pageIndex = 1
        customerData.removeAll()
        selectedCustomer = nil
        
        dataRequestSource = "Search"
        setAttachedURL(SearchText: searchText, IsLoadInactive:false,PageSize: pageSize, PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi(ModelName: "Sale", ActionName: "GetCustomerList", attachedURL: attachedURL)
        
        searchBar.resignFirstResponder()
        
    }
    @IBAction func CancelButtonClick(sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        
        // navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func DoneButtonClick(sender: AnyObject) {
        
        if selectedCustomer == nil {
            
            Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "You haven't select a customer", viewController: self)
        }
        else{
            
            self.delegate?.sendGoBackFromCustomerSearchView(fromView: "CustomerSearchViewController" ,forCell :fromCell,Contact: selectedCustomer!)
            //
            
            _ = navigationController?.popViewController(animated: true)
            
        }
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
