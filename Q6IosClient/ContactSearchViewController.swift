//
//  ContactSearchViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactSearchViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource,UISearchBarDelegate{

    @IBOutlet weak var ContactTableView: UITableView!
    @IBOutlet weak var ContactSearchBox: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        ContactSearchBox.delegate = self
        ContactTableView.delegate = self
        ContactTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func setControlAppear()
    {
        
        ContactSearchBox.layer.cornerRadius = 2;
         ContactSearchBox.layer.borderWidth = 0.1;
         ContactSearchBox.layer.borderColor = UIColor.blackColor().CGColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        self.searchText = searchText
//        
//        if searchText.length == 0 {
//            
//            
//            
//            let q6CommonLib = Q6CommonLib(myObject: self)
//            pageSize = 20
//            pageIndex = 1
//            purchaseTransactionListData.removeAll()
//            
//            dataRequestSource = "Search"
//            print("purchaseTransactionListdata count" + purchaseTransactionListData.count.description)
//            setAttachedURL(searchText, PageSize: 20, PageIndex: pageIndex)
//            q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsList", attachedURL: attachedURL)
//            
//        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCellWithIdentifier("ContactSearchPrototypeCell", forIndexPath: indexPath) as! ContactSearchTableViewCell
        
        cell.lblSupplierID.hidden = true
  
        // Configure the cell...
        
        return cell
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
