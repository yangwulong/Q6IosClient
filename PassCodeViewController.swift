//
//  PassCodeViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//1

import UIKit

class PassCodeViewController: UIViewController , UITextFieldDelegate{

    
  
   // @IBOutlet weak var lblPassCode1: UILabel!
    
    @IBOutlet weak var lblPassCodeScreenTitle: UILabel!
    @IBOutlet weak var txtPassCode1: UITextField!
    @IBOutlet weak var txtPassCode2: UITextField!
    @IBOutlet weak var txtPassCode3: UITextField!
    @IBOutlet weak var txtPassCode4: UITextField!

    let TEXT_FIELD_LIMIT = 1
    
    var firstTimeInputPassCode : String = ""
    var secondTimeInputPassCode: String = ""
    var ValidateTimeInputPassCode: String = ""
    //1 CreatePassCode ,2 ConfirmPassCode ,3 ValidatePassCode
    var ScreenMode : String = ""
    var userInputPasscodeValue1 : String? = nil
      var userInputPasscodeValue2 : String? = nil
      var userInputPasscodeValue3 : String? = nil
      var userInputPasscodeValue4 : String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        self.txtPassCode1.delegate = self
        self.txtPassCode2.delegate = self
        self.txtPassCode3.delegate = self
        self.txtPassCode4.delegate = self
        // Do any additional setup after loading the view.
       txtPassCode1.becomeFirstResponder()
        
   
        
        if ScreenMode == "ValidatePassCode" {
    
      lblPassCodeScreenTitle.text = "Validate Pass Code"
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
public func setControlAppear()
{
    
 txtPassCode1.layer.addBorder(txtPassCode1.frame.width, edge: UIRectEdge.Bottom, color: UIColor.blueColor(), thickness: 0.5)
    
    txtPassCode2.layer.addBorder(txtPassCode2.frame.width, edge: UIRectEdge.Bottom, color: UIColor.blueColor(), thickness: 0.5)
    txtPassCode3.layer.addBorder(txtPassCode3.frame.width, edge: UIRectEdge.Bottom, color: UIColor.blueColor(), thickness: 0.5)
    txtPassCode4.layer.addBorder(txtPassCode4.frame.width, edge: UIRectEdge.Bottom, color: UIColor.blueColor(), thickness: 0.5)
    //lblPassCode1.layer.addBorder(lblPassCode1.frame.width, edge: UIRectEdge.Bottom, color: UIColor.blueColor(), thickness: 0.5)
     // txtTest.layer.addBorder(txtTest.frame.width, edge: UIRectEdge.Bottom, color: UIColor.blueColor(), thickness: 0.5)
    
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //An expression works with Swift 2
        return (textField.text?.utf16.count ?? 0) + string.utf16.count - range.length <= TEXT_FIELD_LIMIT
    }
    
    @IBAction func txtPassCodeEditingChanged(sender: AnyObject) {
        
        if sender.tag == 0 {
            
       userInputPasscodeValue1 = txtPassCode1.text!
            if userInputPasscodeValue1?.length == 1 {
            txtPassCode2.becomeFirstResponder()
            }
        }
        else if sender.tag == 1 {
     
            userInputPasscodeValue2 = txtPassCode2.text!
             if userInputPasscodeValue2?.length == 1 {
            txtPassCode3.becomeFirstResponder()
            }
        }
        else if sender.tag == 2 {
       
             userInputPasscodeValue3 = txtPassCode3.text!
             if userInputPasscodeValue3?.length == 1 {
            txtPassCode4.becomeFirstResponder()
            }
        }
        else if sender.tag == 3{
         
            userInputPasscodeValue4 = txtPassCode4.text!
            
          
             //txtPassCode2.becomeFirstResponder()
        }
        
        print( "Current Screen Mode '\(self.ScreenMode)'")
        if userInputPasscodeValue1 != nil && userInputPasscodeValue2 != nil && userInputPasscodeValue3 != nil && userInputPasscodeValue4 != nil {
            
           
            
            if self.ScreenMode == "ValidatePassCode" {
                
                ValidateTimeInputPassCode = userInputPasscodeValue1!  + userInputPasscodeValue2! + userInputPasscodeValue3! + userInputPasscodeValue4!
                
                
                if ValidateTimeInputPassCode.length == 4 {
                    
                    var q6DBLib = Q6DBLib()
              var userInfos  = q6DBLib.getUserInfos() as [String:String]
           // var passCode = userInfos["passCode"]
                    if userInfos["passCode"] == ValidateTimeInputPassCode {
                        
                        if let tabViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6TabViewController") as? UITabBarController {
                            presentViewController(tabViewController, animated: true, completion: nil)
                        }
                    }
                    else {
                        txtPassCode1.becomeFirstResponder()
                        Q6CommonLib.q6UIAlertPopupController("Error message", message: "Your PassCode is not right,please reenter again", viewController: self)
                        txtPassCode1.text = ""
                        txtPassCode2.text = ""
                        txtPassCode3.text = ""
                        txtPassCode4.text = ""
                        
                        userInputPasscodeValue1 = ""
                        userInputPasscodeValue2 = ""
                        userInputPasscodeValue3 = ""
                        userInputPasscodeValue4 = ""
                        
                        
                        
                    }
                }
           
                
                
            }
       
            
            if self.ScreenMode == "ConfirmPassCode" {
                
                secondTimeInputPassCode = userInputPasscodeValue1!  + userInputPasscodeValue2! + userInputPasscodeValue3! + userInputPasscodeValue4!
                
            
        if secondTimeInputPassCode.length == 4 {
            
            
            if firstTimeInputPassCode == secondTimeInputPassCode{
            
                var q6DBLib = Q6DBLib()
                q6DBLib.editPassCode(secondTimeInputPassCode)
                
                
                            if let tabViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6TabViewController") as? UITabBarController {
                                presentViewController(tabViewController, animated: true, completion: nil)
                            }
            }
            else {
                setToCofirmationScreen()
                Q6CommonLib.q6UIAlertPopupController("Error Message", message: "Your PassCode is different to your first input, please input again", viewController: self)
                
             
                
            }
    
        }
            }
            
            
            if self.ScreenMode == "CreatePassCode" {
                
                firstTimeInputPassCode = userInputPasscodeValue1!  + userInputPasscodeValue2! + userInputPasscodeValue3! + userInputPasscodeValue4!
                
                if firstTimeInputPassCode.length == 4 {
                    
                    if self.ScreenMode == "CreatePassCode" {
                        
                        setToCofirmationScreen()
                    }
                }
            }
            
            
            
        }
    }

    public func setToCofirmationScreen(){
        
        lblPassCodeScreenTitle.text = "Confirm your PassCode"
        txtPassCode1.text = ""
        txtPassCode2.text = ""
        txtPassCode3.text = ""
        txtPassCode4.text = ""
        
        userInputPasscodeValue1 = ""
        userInputPasscodeValue2 = ""
        userInputPasscodeValue3 = ""
        userInputPasscodeValue4 = ""
        ScreenMode = "ConfirmPassCode"
        txtPassCode1.becomeFirstResponder()
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
