//
//  PurchaseViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController, Q6WebApiProtocol {

    var attachedURL: String = "&Type=AllPurchases&ReferenceNo=&StartDate=2016-03-15&EndDate=2016-04-14&PageSize=20&PageIndex=1"
    @IBOutlet weak var PurchaseSearchBox: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        setControlAppear()
  let q6CommonLib = Q6CommonLib(myObject: self)
      
        q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsList", attachedURL: attachedURL)
        
     
     
        // Do any additional setup after loading the view.
    }
    func setControlAppear()
    {
        
        PurchaseSearchBox.layer.cornerRadius = 2;
        PurchaseSearchBox.layer.borderWidth = 0.1;
        PurchaseSearchBox.layer.borderColor = UIColor.blackColor().CGColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        var yy = 6
        return ""
    }

}
