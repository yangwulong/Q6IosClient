//
//  PassCodeViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PassCodeViewController: UIViewController {

    @IBOutlet weak var lblPassCode1: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btnEsc: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
public func setControlAppear()
{
    
    btn1.layer.cornerRadius = 30;
    btn1.layer.borderWidth = 0.1;
    btn1.layer.borderColor = UIColor.blueColor().CGColor
    
    btn2.layer.cornerRadius = 30;
    btn2.layer.borderWidth = 0.1;
    btn2.layer.borderColor = UIColor.blueColor().CGColor
    
    btn3.layer.cornerRadius = 30;
    btn3.layer.borderWidth = 0.1;
    btn3.layer.borderColor = UIColor.blueColor().CGColor
    
    btn4.layer.cornerRadius = 30;
    btn4.layer.borderWidth = 0.1;
    btn4.layer.borderColor = UIColor.blueColor().CGColor
    
    btn5.layer.cornerRadius = 30;
    btn5.layer.borderWidth = 0.1;
    btn5.layer.borderColor = UIColor.blueColor().CGColor
    
    btn6.layer.cornerRadius = 30;
    btn6.layer.borderWidth = 0.1;
    btn6.layer.borderColor = UIColor.blueColor().CGColor
    
    btn7.layer.cornerRadius = 30;
    btn7.layer.borderWidth = 0.1;
    btn7.layer.borderColor = UIColor.blueColor().CGColor
    
    btn8.layer.cornerRadius = 30;
    btn8.layer.borderWidth = 0.1;
    btn8.layer.borderColor = UIColor.blueColor().CGColor
    
    btn9.layer.cornerRadius = 30;
    btn9.layer.borderWidth = 0.1;
    btn9.layer.borderColor = UIColor.blueColor().CGColor
    
    btnSkip.layer.cornerRadius = 30;
    btnSkip.layer.borderWidth = 0.1;
    btnSkip.layer.borderColor = UIColor.blueColor().CGColor
    
    btn0.layer.cornerRadius = 30;
    btn0.layer.borderWidth = 0.1;
    btn0.layer.borderColor = UIColor.blueColor().CGColor
    
    btnEsc.layer.cornerRadius = 30;
    btnEsc.layer.borderWidth = 0.1;
    btnEsc.layer.borderColor = UIColor.blueColor().CGColor
    
    
    lblPassCode1.layer.addBorder(lblPassCode1.frame.width, edge: UIRectEdge.Bottom, color: UIColor.blueColor(), thickness: 0.5)
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
