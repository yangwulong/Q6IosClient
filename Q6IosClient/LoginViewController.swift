// ziliangcai
//
//  LoginViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 22/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//  2
import UIKit

// ziliang

class LoginViewController: UIViewController, UITextFieldDelegate,Q6WebApiProtocol {
    
    var activeField: UITextField?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var txtLoginEmail: UITextField!
    @IBOutlet weak var txtLoginPassword: UITextField!
    
    @IBOutlet weak var imgQ6Logo: UIImageView!
    @IBOutlet weak var btnSignIn: UIButton!
    
    var ScreenMode : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
      
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        
       
        let height = bounds.size.height
        
        scrollView.frame.size = CGSize(width:width, height:height)
        scrollView.contentSize = CGSize(width:width, height:height)
        txtLoginEmail.frame.size.width = width - 50
        txtLoginPassword.frame.size.width = width - 50
        btnSignIn.frame.size.width = width - 50 
        let q6IosClientDB = Q6DBLib()
        
        q6IosClientDB.createDB()
        
        Q6ActivityIndicatorView.hidesWhenStopped = true
        Q6ActivityIndicatorView.stopAnimating()
        let loginStatus = q6IosClientDB.validateLoginStatus()
        
        if loginStatus == true && ScreenMode == "" {
            imgQ6Logo.isHidden = true
            txtLoginEmail.isHidden = true
            txtLoginPassword.isHidden = true
            btnSignIn.isHidden = true
        } else {
            imgQ6Logo.isHidden = false
            txtLoginEmail.isHidden = false
            txtLoginPassword.isHidden = false
            btnSignIn.isHidden = false
        }
        
        registerForKeyboardNotifications()
        
    }
    override  func viewDidLoad() {
        super.viewDidLoad()
        setControlAppear()
        txtLoginPassword.delegate = self
        txtLoginEmail.delegate = self
        let q6IosClientDB = Q6DBLib()
        
        q6IosClientDB.createDB()
        
     //   var isEmpty = q6IosClientDB.validateIfTableIsEmpty("UserInfos")
        
     //   var loginStatus = q6IosClientDB.validateLoginStatus()
        
        //        if loginStatus == true {
        ////            if let tabViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6TabViewController") as? UITabBarController {
        ////                presentViewController(tabViewController, animated: true, completion: nil)
        //            }
        // }
        
        //        var IP = Q6CommonLib.getIPAddresses()
        //        // Do any additional setup after loading the view.
        //        var dd = Q6CommonLib.isConnectedToNetwork()
    }
    override  func viewDidAppear(_ animated: Bool) {
        
        let q6IosClientDB = Q6DBLib()
        
        q6IosClientDB.createDB()
        
        let loginStatus = q6IosClientDB.validateLoginStatus()
        
        if loginStatus == true && ScreenMode == "" {
            
            if let passCodeViewController = storyboard!.instantiateViewController(withIdentifier: "Q6PassCodeViewController") as? PassCodeViewController {
                
                passCodeViewController.ScreenMode = "ValidatePassCode"
                
                present(passCodeViewController, animated: true, completion: nil)
            }
            ScreenMode = ""
            
            
        }
        
    }
    
    @IBAction func SwipeGestureRecognizerEvent(sender: AnyObject) {
        
        print("swipe")
    }
    @IBAction func TapGestureRecognizerEvent(sender: UITapGestureRecognizer) {
        txtLoginEmail.resignFirstResponder()
        txtLoginPassword.resignFirstResponder()
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    
        print("tap")
    }
    
    @IBAction func SignIn(sender: AnyObject) {
        
        txtLoginPassword.resignFirstResponder()
        txtLoginEmail.resignFirstResponder()
        insideSignIn()
   
    }
    func insideSignIn()
    {
        
        let isInputValid = validaUserInput()
        
        if isInputValid == true {
            
            let isConnectedToNetwork = Q6CommonLib.isConnectedToNetwork()
            
            if isConnectedToNetwork == true {
                let q6CommonLib = Q6CommonLib(myObject: self)
                
                
                var dicData=[String: String]()
                dicData["WebApiTOKEN"]=Q6CommonLib.getQ6WebAPIToken()
                dicData["LoginUserName"]=txtLoginEmail.text
                dicData["Password"]=txtLoginPassword.text
                dicData["ClientIP"]=Q6CommonLib.getIPAddresses()
                
                print("Q6CommonLib.getIPAddresses()" + Q6CommonLib.getIPAddresses())
                Q6ActivityIndicatorView.startAnimating()
                q6CommonLib.Q6IosClientPostAPI(ModeName: "Q6",ActionName: "InternalUserLogin", dicData:dicData as [String : AnyObject])
                
                //  Q6ActivityIndicatorView.startAnimating()
                // Q6CommonLib.popUpLoadingSign(self)
            }
            else{
                
            }
        }
        else{
            
        }
    }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtLoginEmail.resignFirstResponder()
        txtLoginPassword.resignFirstResponder()
        
        //validaUserInput()
    }
    @IBAction func txtLoginEmailExit(sender: AnyObject) {
        
        
       _ = validaUserInput()
    }
    
    func validaUserInput() -> Bool
    {
        let isEmailAddressValid = Q6CommonLib.isEmailAddressValid(email: txtLoginEmail.text!)
        
        if isEmailAddressValid == false {
            Q6CommonLib.q6UIAlertPopupController(title: "Login Error", message: "Your email address is not valid!", viewController: self)
        }
        
        return isEmailAddressValid
    }
    func setControlAppear()
    {
        
//        txtLoginEmail.layer.cornerRadius = 2;
//        txtLoginEmail.layer.borderWidth = 0.1;
//        txtLoginEmail.layer.borderColor = UIColor.black.cgColor
//        
//        txtLoginPassword.layer.cornerRadius = 2;
//        txtLoginPassword.layer.borderWidth = 0.1;
//        txtLoginPassword.layer.borderColor = UIColor.black.cgColor
        
        btnSignIn.layer.cornerRadius = 5;
        btnSignIn.layer.borderWidth = 0.1;
        btnSignIn.layer.borderColor = UIColor.black.cgColor
    }
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    {
        
        var postDicData :[String:AnyObject]?
//        var IsLoginSuccessed : Bool = false
        do {
            postDicData = try  JSONSerialization.jsonObject(with: data! as Data, options: []) as? [String:AnyObject]
            print("postDictData: \(postDicData!)")
            if postDicData != nil {
            let IsLoginSuccessed = (postDicData!["IsSuccessed"] as! NSString).boolValue
            
                if IsLoginSuccessed == true {
                    
                    
                    var returnValue = postDicData!["ReturnValue"]! as! Dictionary<String, AnyObject>
                    
                    let companyID = returnValue["CompanyID"] as! String
                    let LoginFirstName = returnValue["LoginFirstName"] as! String
                    let LoginLastName = returnValue["LoginLastName"] as! String
                    
                    
                    let q6DBLib = Q6DBLib()
                    
                    
                    q6DBLib.addUserInfos(LoginEmail: txtLoginEmail.text!, PassWord: txtLoginPassword.text!, LoginStatus: "Login",CompanyID: companyID ,LoginFirstName: LoginFirstName ,LoginLastName: LoginLastName)
                    //Set any attributes of the view controller before it is displayed, this is where you would set the category text in your code.
                    
                    let passCode = q6DBLib.getUserPassCode()
                    
                    if let passCodeViewController = storyboard!.instantiateViewController(withIdentifier: "Q6PassCodeViewController") as? PassCodeViewController {
                        
                        if passCode == nil {
                            
                            passCodeViewController.ScreenMode = "CreatePassCode"
                        } else if passCode != nil {
                            
                            if passCode!.length == 0 {
                                passCodeViewController.ScreenMode = "CreatePassCode"
                            }
                            
                        } else {
                            
                            passCodeViewController.ScreenMode = "ValidatePassCode"
                        }
                        
                        present(passCodeViewController, animated: true, completion: nil)
                    }
                    
                }else {
                    
                    activityIndicatorViewStop()
                    Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "Login fail ,Please check your login name ,password!", viewController: self)
                }
            }
            else {
                
                activityIndicatorViewStop()
                Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "Login fail ,Please check your login name ,password!", viewController: self)
            }
            
            
        } catch  {
            
            Q6CommonLib.q6UIAlertPopupController(title: "Information Message", message: "Login fail ,Please check your login name ,password!", viewController: self)
            
            activityIndicatorViewStop()
            
            print("error parsing response from POST on /posts")
            
            return "" as AnyObject
        }
        
        //
        return "" as AnyObject
    }
    
    private func activityIndicatorViewStop() {
        DispatchQueue.main.async {
            
            
            self.Q6ActivityIndicatorView.hidesWhenStopped = true
            self.Q6ActivityIndicatorView.stopAnimating()
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        insideSignIn()
        return true;
    }
    
//    override func viewWillAppear(animated: Bool) {
//        registerForKeyboardNotifications()
//    }
    override open func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications()
    {
       
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
//        //Adding notifies on keyboard appearing
//        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWasShown:"), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillBeHidden:"), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeField != nil
        {
            if (!aRect.contains(activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(_ notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
        
    }
    
 
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
    }
    
}
