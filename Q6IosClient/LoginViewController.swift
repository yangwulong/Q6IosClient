//
//  LoginViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 22/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtLoginEmail: UITextField!
    @IBOutlet weak var txtLoginPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        
        var IP = Q6CommonLib.getIPAddresses()
        // Do any additional setup after loading the view.
        var dd = IP
    }

 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtLoginEmail.resignFirstResponder()
        txtLoginPassword.resignFirstResponder()
        
    validaUserInput()
    }
    @IBAction func txtLoginEmailExit(sender: AnyObject) {
        
       
   validaUserInput()
    }
    
    func validaUserInput()
    {
        let isEmailAddressValid = Q6CommonLib.isEmailAddressValid(txtLoginEmail.text!)
        
        if isEmailAddressValid == false {
            Q6CommonLib.q6UIAlertPopupController("Login Error", message: "Your email address is not valid!", viewController: self)
        }
    }
func setControlAppear()
{
    
    txtLoginEmail.layer.cornerRadius = 2;
    txtLoginEmail.layer.borderWidth = 0.1;
    txtLoginEmail.layer.borderColor = UIColor.blackColor().CGColor
    
    txtLoginPassword.layer.cornerRadius = 2;
    txtLoginPassword.layer.borderWidth = 0.1;
    txtLoginPassword.layer.borderColor = UIColor.blackColor().CGColor
    
    btnSignIn.layer.cornerRadius = 2;
    btnSignIn.layer.borderWidth = 0.1;
    btnSignIn.layer.borderColor = UIColor.blackColor().CGColor
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
