//
//  SaleDetailDataLineTaxCodeViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 14/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailDataLineTaxCodeSearchViewController:UIViewController, Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var Q6ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var TaxCodeTableView: UITableView!
    @IBOutlet weak var taxCodeSearchBox: UISearchBar!
    var dataRequestSource = ""
    var taxCodeViewData = [TaxCodeView]()
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    var attachedURL = String()
    var searchText: String = ""
    
    var pageIndex: Int = 1
    var pageSize: Int = 1000
    
    var selectedTaxCodeView:TaxCodeView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        TaxCodeTableView.delegate = self
        TaxCodeTableView.dataSource = self
        taxCodeSearchBox.delegate = self
        Q6ActivityIndicator.startAnimating()
        // Do any additional setup after loading the view.
        setControlAppear()
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        setAttachedURL(TaxCodeName: "", TaxCodeType:"CollectTax",IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi(ModelName: "Company", ActionName: "GetTaxCodeList", attachedURL: attachedURL)
        
    }
    
    func setControlAppear()
    {
        
        taxCodeSearchBox.layer.cornerRadius = 2;
        taxCodeSearchBox.layer.borderWidth = 0.1;
        taxCodeSearchBox.layer.borderColor = UIColor.black.cgColor
    }
    
    //TaxCodeType All ,CollectTax ,PayTax
    func setAttachedURL(TaxCodeName:String ,TaxCodeType: String ,IsLoadInactive:Bool,PageSize: Int,PageIndex: Int )
    {
        attachedURL =  "&TaxCodeName=" + TaxCodeName + "&TaxCodeType=" + TaxCodeType + "&IsLoadInactive=" + String(IsLoadInactive) + "&PageSize=" + String(PageSize) + "&PageIndex=" + String(PageIndex)
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
        return taxCodeViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "TaxCodeCell", for: indexPath) as! SaleDetailDataLineTaxCodeSearchTableViewCell
        
        cell.lblTaxCodeName.text = taxCodeViewData[indexPath.row].TaxCodeName
        
        let taxRate = taxCodeViewData[indexPath.row].TaxRate
        let taxRateWithTwoDecimalPlaces = String(format: "%.2f", taxRate)
        cell.lblTaxRate.text = String(taxRateWithTwoDecimalPlaces) + "%"
        //        cell.lblSupplierID.hidden = true
        //
        //
        //        cell.lblSupplierName.text =  supplierData[indexPath.row].SupplierName
        //
        //        cell.lblSupplierID.text =  supplierData[indexPath.row].SupplierID
        
        // Configure the cell...
        
        return cell
    }
    
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
        
        do {
            if dataRequestSource == "Search" {
                taxCodeViewData.removeAll()
                selectedTaxCodeView = nil
            }
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as! [String:AnyObject]
            
            var returnData = postDicData["TaxCodeList"] as! [[String : AnyObject]]
            print("returnDate Count" + returnData.count.description)
            //
            for i in 0  ..< returnData.count {
                
                //
                //                print("no i =" + i.description)
                var dataItem = returnData[i]
                
                let taxCodeView = TaxCodeView()
                taxCodeView.TaxCodeID = dataItem["TaxCodeID"] as! String
                
                
                taxCodeView.TaxCodeName = dataItem["TaxCodeName"] as! String
                
                taxCodeView.TaxRate = dataItem["TaxRate"] as! Double
                
                taxCodeViewData.append(taxCodeView)
                //
                //                printFields(purchasesTransactionListViewDataItem)
            }
            //
            //            print("supplier Date Count" + supplierData.count.description)
            //
            DispatchQueue.main.async {
                self.TaxCodeTableView.reloadData()
                self.Q6ActivityIndicator.hidesWhenStopped = true
                self.Q6ActivityIndicator.stopAnimating()
                self.taxCodeSearchBox.resignFirstResponder()
                
            }
            //
            //
            //
        } catch  {
            print("error parsing response from POST on /posts")
            
            return "" as AnyObject
        }
        
        return "" as AnyObject
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTaxCodeView = taxCodeViewData[indexPath.row]
        taxCodeSearchBox.resignFirstResponder()
    }
    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        if selectedTaxCodeView == nil {
            
            Q6CommonLib.q6UIAlertPopupController(title: "Error message", message: "You haven't select a TaxCode", viewController: self)
        }
        else{
            
            self.delegate?.sendGoBackFromSaleDetailDataLineTaxCodeSearchView(fromView: "SaleDetailDataLineTaxCodeSearchViewController", forCell: "TaxCodeCell", taxCodeView: selectedTaxCodeView!)
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        
        if searchText.length == 0 {
            
            
            
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            
            taxCodeViewData.removeAll()
            selectedTaxCodeView = nil
            
            dataRequestSource = "Search"
            
            setAttachedURL(TaxCodeName: searchText, TaxCodeType:"CollectTax",IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
            q6CommonLib.Q6IosClientGetApi(ModelName: "Company", ActionName: "GetTaxCodeList", attachedURL: attachedURL)
            
        }
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar)
    {
        
        
        
        taxCodeViewData.removeAll()
        selectedTaxCodeView = nil
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        setAttachedURL(TaxCodeName: searchText, TaxCodeType:"CollectTax",IsLoadInactive:false,PageSize: pageSize,PageIndex: pageIndex)
        q6CommonLib.Q6IosClientGetApi(ModelName: "Company", ActionName: "GetTaxCodeList", attachedURL: attachedURL)
        taxCodeSearchBox.resignFirstResponder()
        
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
