//
//  PurchaseDetailViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 3/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView {


   // @IBOutlet weak var lblPurchasesType: UILabel!
    @IBOutlet var purchaseDetailTableView: UITableView!
    //@IBOutlet weak var lblTotalAmount: UILabel!
    //@IBOutlet weak var lblTotalLabel: UILabel!
    
    var purchasesDetailScreenLinesDic = [ScreenSortLinesDetail]()
    
    var originalRowsDic: [Int: String] = [0: "PurchasesTypecell", 1: "SupplierCell",2: "DueDateCell",3: "AddanItemCell",4: "SubtotalCell",5: "TotalCell",6: "TransactionDateCell",7: "MemoCell",8: "AddanImageCell"]
    var addItemsDic = [Int:String]()
    
    var backFrom = String()
    
    var purchasesTransactionHeader = PurchasesTransactionsHeader()
    var SupplierName: String = ""
   
   
    override func viewWillAppear(animated: Bool) {
        
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setScreenSortLines()
        print("purchasesDetailScreenLinesDic" + purchasesDetailScreenLinesDic.count.description)
     setControlAppear()
        
        purchaseDetailTableView.delegate = self
        purchaseDetailTableView.dataSource = self
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func setScreenSortLines()
    {
        if ValidteWhetherHasAddedLinesInPurchasesDetailScreenLinesDic() == false
        {
            for index in 0 ... 8 {
                
                var screenSortLinesDetail = ScreenSortLinesDetail()
                var prototypeCell = String()
                
                switch index {
                case 0:
                    prototypeCell = "PurchasesTypecell"
                case 1:
                    prototypeCell = "SupplierCell"
                case 2:
                    prototypeCell = "DueDateCell"
                case 3:
                    prototypeCell = "AddanItemCell"
                case 4:
                    prototypeCell = "SubtotalCell"
                case 5:
                    prototypeCell = "TotalCell"
                case 6:
                    prototypeCell = "TransactionDateCell"
                case 7:
                    prototypeCell = "MemoCell"
                case 8:
                    prototypeCell = "AddanImageCell"
                default:
                    prototypeCell = ""
                }
                
                screenSortLinesDetail.ID = index
                screenSortLinesDetail.PrototypeCellID = prototypeCell
                screenSortLinesDetail.LineDescription = "OriginalLine"
                
                purchasesDetailScreenLinesDic.append(screenSortLinesDetail)
                
            }
        }
        
    }
    func setControlAppear()
    {
       // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
       
        purchaseDetailTableView.tableFooterView = UIView(frame: CGRectZero)
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
        return purchasesDetailScreenLinesDic.count
    }

   
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var resuseIdentifier = String()
        if indexPath.row <= 8 {
       resuseIdentifier = originalRowsDic[indexPath.row]!
        }
        if indexPath.row > 8 {
             resuseIdentifier = originalRowsDic[5]!
        }
      
     var screenSortLinesDetail = purchasesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        
        resuseIdentifier = screenSortLinesDetail.PrototypeCellID
        let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! PurchaseDetailTableViewCell
        
        
        if resuseIdentifier == "PurchasesTypecell" {
            
       cell.lblPurchasesType.text = purchasesTransactionHeader.PurchasesType
            
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "SupplierCell" {
            
        cell.lblSupplierName.text = SupplierName
            
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "DueDateCell" {
            
            if purchasesTransactionHeader.DueDate == nil {
                
            
          purchasesTransactionHeader.DueDate = NSDate()
            }
          
//
         cell.lblDueDate.text = purchasesTransactionHeader.DueDate!.formatted
            
            
   
        }
        
        if resuseIdentifier == "AddanItemCell" {
            
            if purchasesDetailScreenLinesDic[indexPath.row].isAdded == true {
                
                let image = UIImage(named: "Minus-25") as UIImage?
             
             
                
               // let image = UIImage(named: "name") as UIImage?
        // cell.AddDeleteButton = UIButton(type: .System) as UIButton
      
                
           cell.AddDeleteButton.setImage(image, forState: .Normal)
           cell.LineDescription.text = "Added dataLine"
             //   cell.AddDeleteButton.frame = CGRectMake(0, 0, 15, 15)
              //  cell.AddDeleteButton = UIButton(type: UIButtonType.Custom)
            }
            
        }
        
        
            if resuseIdentifier == "TotalCell" {
                
                cell.lblTotalAmountLabel.font = UIFont.boldSystemFontOfSize(17.0)
                cell.lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
                
                
                // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
                //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
            }
            return cell
   

        // Configure the cell...
        print("indexPath" + indexPath.row.description)
    
        //return cell
    }
 
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row //2
        
        print("Selected Row" + indexPath.row.description)
        var screenSortLinesDetail = purchasesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        print("screenSortLinesDetail.PrototypeCellID" + screenSortLinesDetail.PrototypeCellID)
        if screenSortLinesDetail.PrototypeCellID == "PurchasesTypecell" {
            
            performSegueWithIdentifier("showPickerView", sender: "PurchasesTypecell")

            
        }
        if screenSortLinesDetail.PrototypeCellID == "SupplierCell" {
            
            performSegueWithIdentifier("showContactSearch", sender: "SupplierCell")
            
            
        }
        if screenSortLinesDetail.PrototypeCellID == "DueDateCell" {
            
            performSegueWithIdentifier("showDatePicker", sender: "DueDateCell")
            
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "AddanItemCell" {
            
           
             performSegueWithIdentifier("showItemDetail", sender: "AddanItemCell")
//            if purchasesDetailScreenLinesDic[indexPath.row].isAdded == false {
//            var screenSortLinesDetail = ScreenSortLinesDetail()
//            screenSortLinesDetail.ID = indexPath.row + 1
//            print("ScreenSortLinesDetailID" + screenSortLinesDetail.ID.description )
//            screenSortLinesDetail.PrototypeCellID = "AddanItemCell"
//            screenSortLinesDetail.LineDescription = "AddedLine"
//            screenSortLinesDetail.isAdded = true
//            
//            
//          purchasesDetailScreenLinesDic.insert(screenSortLinesDetail, atIndex: 4 )
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.purchaseDetailTableView.reloadData()
//                
//            })
//            }
            
        }
        var index = addItemsDic.count
        addItemsDic[index] = "One more Item"
       // let section = indexPath.section//3
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//        self.purchaseDetailTableView.reloadData()
//            })
//        let order = menuItems.items[section][row] + " " + menuItems.sections[section] //4
       // navigationItem.title = order
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if sender is String {
            
       let fromCell = sender as! String
//        if let fromCell = sender as? String {
           
            if fromCell == "PurchasesTypecell"
            {
                    var pickerViewController = segue.destinationViewController as! PickerViewViewController
           pickerViewController.fromCell = "PurchasesTypecell"
                
                pickerViewController.delegate = self
            }
            if fromCell == "SupplierCell"
            {
                
                var contactSearchViewController = segue.destinationViewController as! ContactSearchViewController
                contactSearchViewController.fromCell = "SupplierCell"
                contactSearchViewController.delegate = self
                
            }
            
            if fromCell == "DueDateCell"
            {
                
                var datePickerViewController = segue.destinationViewController as! DatePickerViewController
                datePickerViewController.fromCell = "DueDateCell"
                datePickerViewController.delegate = self
                
            }
        }

    }
    
    @IBAction func CancelButtonClick(sender: AnyObject) {
       
//        if let purchaseViewController = storyboard!.instantiateViewControllerWithIdentifier("PurchaseViewController") as? PurchaseViewController {
//    
//            presentViewController(purchaseViewController, animated: true, completion: nil)
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
    func searchLastAddedIndexInPurchaseDetailScreenLinesDic() -> Int? {
        
        var indexPath = Int?()
        
        
        for index in 0 ..< purchasesDetailScreenLinesDic.count {
            var screenSortLinesDetail = purchasesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
            if screenSortLinesDetail.isAdded == true {
              indexPath = index
            }
        }
        return indexPath
    }
    
    func ValidteWhetherHasAddedLinesInPurchasesDetailScreenLinesDic() -> Bool {
        
        for index in 0 ..< purchasesDetailScreenLinesDic.count {
          var screenSortLinesDetail = purchasesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
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
            if forCell == "PurchasesTypecell" {
                
             purchasesTransactionHeader.PurchasesType = selectedValue
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
           self.purchaseDetailTableView.reloadData()
                    
                })
                
            }
        }
        print("backFrom" + self.backFrom)
    }
    
    func  sendGoBackFromContactSearchView(fromView : String ,forCell: String,ContactID : String ,ContactName: String){

        if fromView == "ContactSearchViewController" {
            if forCell == "SupplierCell" {
                purchasesTransactionHeader.SupplierID = ContactID
                SupplierName = ContactName
                
                print("purchasesTransactionHeader.SupplierID" + purchasesTransactionHeader.SupplierID)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
            }
        }
      
       
}
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
    {
        if fromView == "DatePickerViewController" {
            if forCell == "DueDateCell" {
                purchasesTransactionHeader.DueDate = Date
            
                
          
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
                
    }
        }
    }
    
 
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetail: PurchasesTransactionsDetail){
        
    }
    func sendGoBackFromPreLoadInventoryPurchaseView(fromView:String,forCell:String,preLoadInventoryPurchase: PreLoadInventoryPurchase){
        
    }
    
     func  sendGoBackFromPurchaseDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
     {
        
    }
    
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
