//
//  PurchaseDetailViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 3/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailViewController: UITableViewController {


    @IBOutlet var purchaseDetailTableView: UITableView!
    //@IBOutlet weak var lblTotalAmount: UILabel!
    //@IBOutlet weak var lblTotalLabel: UILabel!
    
    var purchasesDetailScreenLinesDic = [ScreenSortLinesDetail]()
    
    var originalRowsDic: [Int: String] = [0: "PurchasesTypecell", 1: "SupplierCell",2: "DueDateCell",3: "AddanItemCell",4: "SubtotalCell",5: "TotalCell",6: "TransactionDateCell",7: "MemoCell",8: "AddanImageCell"]
    var addItemsDic = [Int:String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        setScreenSortLines()
        print("purchasesDetailScreenLinesDic" + purchasesDetailScreenLinesDic.count.description)
     setControlAppear()
        
      
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
       // print("addItemsDic" + addItemsDic.count.description)
       // return originalRowsDic.count + addItemsDic.count
        return purchasesDetailScreenLinesDic.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row //2
        
        print("Selected Row" + indexPath.row.description)
        var screenSortLinesDetail = purchasesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        print("screenSortLinesDetail.PrototypeCellID" + screenSortLinesDetail.PrototypeCellID)
        if screenSortLinesDetail.PrototypeCellID == "PurchasesTypecell" {
            
            if let pickerViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6PickerViewController") as? PickerViewViewController {
//
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
               // let mainVC = storyboard.instantiateViewControllerWithIdentifier("secondVC") as! UIViewController
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: .CurveEaseInOut , animations: { () -> Void in
                    appDelegate.window!.rootViewController = pickerViewController
                    },  completion: { finished in
                     pickerViewController.presentingViewController!                      
                })
         // presentViewController(pickerViewController, animated: true, completion: nil)
            }
            
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
        if let pickerViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6PickerViewController") as? PickerViewViewController {
//            pickerViewController.view.transform = CGAffineTransformMakeTranslation(-600, 0)
//            
//                    UIView.animateWithDuration(0.25,
//                                               delay: 0.0,
//                                               options: UIViewAnimationOptions.CurveEaseInOut,
//                                               animations: {
//                                                pickerViewController.view.transform = CGAffineTransformMakeTranslation(0, 0)
//                        },
//                                               completion: { finished in
//                                                self.presentViewController(pickerViewController, animated: true, completion: nil)
//                        }
//                  )
//            
//
//        if segue.identifier == "fromPurchasesTypeCell"{
////            let vc = segue.destinationViewController as! FooTwoViewController
////            vc.colorString = colorLabel.text
//       
//        }
    }
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
