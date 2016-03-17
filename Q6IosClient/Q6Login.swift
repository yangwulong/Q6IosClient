//
//  File.swift
//  Q6IosClient
//
//  Created by yang wulong on 17/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
import LocalAuthentication
import UIKit

public class Q6Login
{
    
    
    func validateIfTouchIDExist()->Bool{
        
        let context = LAContext()
        
        var error: NSError?
        
    
        if context.canEvaluatePolicy(
            LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            error: &error) {
                return true
        }
        else{
            return false
            
        }
    }
    
    func  validateIfPassCodeExist() -> Bool {
        let secret = "Device has passcode set?".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let attributes = [kSecClass as String:kSecClassGenericPassword, kSecAttrService as String:"LocalDeviceServices", kSecAttrAccount as String:"NoAccount", kSecValueData as String:secret!, kSecAttrAccessible as String:kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly]
        
        let status = SecItemAdd(attributes, nil)
        if status == 0 {
            SecItemDelete(attributes)
            return true
        }
        
        return false
    }
    func testTouchID()->(msg:String,err:String) {
        
        var msg: String = ""
        var err: String = ""
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(
            LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
            error: &error) {
                
                context.evaluatePolicy(
                    LAPolicy.DeviceOwnerAuthenticationWithBiometrics,
                    localizedReason: "Access requires authentication",
                    reply: {(success, error) in
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            if error != nil {
                                
                                switch error!.code {
                                    
                                case LAError.SystemCancel.rawValue:
                                  
                                    msg = "Session cancelled"
                                    err = (error?.localizedDescription)!
                                  
                                    
                                case LAError.UserCancel.rawValue:
                                 
                           
                                     msg = "Please try again"
                                     err = (error?.localizedDescription)!
                                    
                                case LAError.UserFallback.rawValue:
                       
                                    // Custom code to obtain password here
                                    msg = "Authentication"
                                    err = "Password option selected"
                                    
                                default:
                           
                                    msg = "Authentication failed"
                                    err = (error?.localizedDescription)!
                                }
                                
                            } else {
                       
                                msg = "Authentication Successful"
                                err = "You now have full access"
                            }
                        }
                })
                
                
        } else {
            // Device cannot use TouchID
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                notifyUser("TouchID is not enrolled",
                    err: error?.localizedDescription)
                msg = "TouchID is not enrolled"
                err = (error?.localizedDescription)!
                
            case LAError.PasscodeNotSet.rawValue:
          
                msg = "A passcode has not been set"
                err = (error?.localizedDescription)!
                
            default:
      
                
                msg = "TouchID not available"
                err = (error?.localizedDescription)!
                
            }
        }
        return (msg ,err)
    }
    
    func notifyUser(msg: String, err: String?) {
//        let alert = UIAlertController(title: msg, 
//            message: err, 
//            preferredStyle: UIAlertControllerStyle.Alert)
//        
//        let cancelAction = UIAlertAction(title: "OK", 
//            style: .Cancel, handler: nil)
//        
//        alert.addAction(cancelAction)
//        
//        self.presentViewController(alert, animated: true, 
//            completion: nil)
    }
    

}