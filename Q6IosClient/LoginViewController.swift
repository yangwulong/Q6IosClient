//
//  LoginViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 22/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, Q6WebApiProtocol {

    @IBOutlet weak var txtLoginEmail: UITextField!
    @IBOutlet weak var txtLoginPassword: UITextField!
  
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewWillAppear(animated: Bool) {
//        var q6CommonLib = Q6CommonLib()
//        q6CommonLib.testTouchID()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        
        
        let q6IosClientDB = Q6DBLib()
        
         q6IosClientDB.createDB()
        
     var isEmpty = q6IosClientDB.validateIfTableIsEmpty("UserInfos")
//        var IP = Q6CommonLib.getIPAddresses()
//        // Do any additional setup after loading the view.
//        var dd = Q6CommonLib.isConnectedToNetwork()
    }

 

    @IBAction func SignIn(sender: AnyObject) {
        
        let isInputValid = validaUserInput()
        
        if isInputValid == true {
            
        let isConnectedToNetwork = Q6CommonLib.isConnectedToNetwork()
            if isConnectedToNetwork == true {
        let q6CommonLib = Q6CommonLib(myObject: self)
        
        
        var dicData=[String:String]()
        dicData["WebApiTOKEN"]=Q6CommonLib.getQ6WebAPIToken()
        dicData["LoginUserName"]=txtLoginEmail.text
        dicData["Password"]=txtLoginPassword.text
        dicData["ClientIP"]=Q6CommonLib.getIPAddresses()
        
        q6CommonLib.Q6IosClientPostAPI("InternalUserLogin", dicData:dicData)
            }
            else{
                
            }
        }
        else{
            
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtLoginEmail.resignFirstResponder()
        txtLoginPassword.resignFirstResponder()
        
    validaUserInput()
    }
    @IBAction func txtLoginEmailExit(sender: AnyObject) {
        
       
   validaUserInput()
    }
    
    func validaUserInput() -> Bool
    {
        let isEmailAddressValid = Q6CommonLib.isEmailAddressValid(txtLoginEmail.text!)
        
        if isEmailAddressValid == false {
            Q6CommonLib.q6UIAlertPopupController("Login Error", message: "Your email address is not valid!", viewController: self)
        }
        
        return isEmailAddressValid
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
    
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        
        
        var postDicData :[String:AnyObject]
        var IsLoginSuccessed : Bool
        do {
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            
            IsLoginSuccessed = postDicData["IsSuccessed"] as! Bool
            
            if IsLoginSuccessed == true {
           
                var q6DBLib = Q6DBLib()
                
               q6DBLib.addUserInfos(txtLoginEmail.text!, PassWord: txtLoginPassword.text!, LoginStatus: "Login")
                //Set any attributes of the view controller before it is displayed, this is where you would set the category text in your code.
                
                if let tabViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6TabViewController") as? UITabBarController {
                    presentViewController(tabViewController, animated: true, completion: nil)
                }
            }
            
            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }
        
        
        return ""
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
