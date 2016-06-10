//
//  SaleDetailMemoViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailMemoViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    
    var fromCell = String()
    weak var delegate : Q6GoBackFromView?
    var strMemo = String()
    
    var textValue = ""
    
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
