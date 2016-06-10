//
//  SaleDetailDataLineViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailDataLineViewController: UIViewController {

    
    @IBOutlet weak var SaleDetailDataLineTableView: UITableView!
    var originalRowsDic: [Int: String] = [0: "InventoryCell", 1: "AccountCell",2: "DescriptionCell",3: "QuantityCell",4: "UnitPriceCell",5: "TaxCodeCell",6: "AmountCell"]
    
    
    var strDescription = String()
    var salesTransactionsDetailView = SalesTransactionsDetailView()
    var salesTransactionHeader = SalesTransactionsHeader()
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    var selectedInventoryView = InventoryView?()
    var selectedAccountView = AccountView?()
    var customer = Customer?()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

}
