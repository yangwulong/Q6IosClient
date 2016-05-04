//
//  PickerViewViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PickerViewViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
      self.view.transform = CGAffineTransformMakeTranslation(600, 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Do any additional setup after loading the view.
    }
    override func animationDidStart(anim: CAAnimation) {
        
        var ff = 5
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
