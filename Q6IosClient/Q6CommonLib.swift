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
import SystemConfiguration

public class Q6CommonLib{
    
     let q6WebApiUrl = "http://api.q6.com.au/api/Q6/"
     weak var delegate : Q6WebApiProtocol?
    init(){}
    
    init(myObject: MasterViewController){
      
        self.delegate = myObject
    }
    
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
    func convertJSONToDictionary(text: String?) -> [String:AnyObject]? {
        if let data = text!.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func convertDictionaryToJSONData(dicData:[String:AnyObject])-> String
    {
        var returnString = ""
        
        do{
            
            let jsonData = try NSJSONSerialization.dataWithJSONObject(dicData, options: [])
            
            let  jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            returnString = jsonString
            print(jsonString)
        }catch{
            
        }
        
        
        return returnString
    }

    
    func Q6IosClientPostAPI(ActionName: String, dicData:[String:AnyObject]){
        
        var UrlString = q6WebApiUrl  + ActionName;
        
        
        // create the request & response
        var request = NSMutableURLRequest(URL: NSURL(string: UrlString)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
        
        
        
        // create some JSON data and configure the request
        let jsonString = convertDictionaryToJSONData(dicData)
        
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        

        do {
            // let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
            // postsUrlRequest.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)//jsonPost
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
         
  
            
            
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error)  in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    print(error)
                    return
                }
                guard let myResponse = response else {
                    print("error calling response")
                    print(error)
                    return
                }
           
       
                self.completion(data, response: response, error: error)
                // parse the result as JSON, since that's what the API provides
       
             

            })
            
            
            task.resume()
//
            
           
        }
    
    }

 
   public func completion(data:NSData?, response:NSURLResponse?, error:NSError?) {
        
        self.delegate?.dataLoadCompletion(data, response: response, error: error)
     
        
    }
    
    
    
    public static func isEmailAddressValid(email: String) -> Bool {
        
        var filterString: String
        
        filterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
     
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", filterString)
        
        return emailTest.evaluateWithObject(email)
    }
    
    public static func q6UIAlertPopupController(title: String?,message:String?,viewController: AnyObject?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
       viewController!.presentViewController(alert, animated: true, completion: nil)
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                                      Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            viewController!.dismissViewControllerAnimated(true, completion: nil);
        }
    }
    
    // changed return from [String] to String
     //addresses[0] return public IP ,addresses[1] return private ip
    static func getIPAddresses() -> String {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return addresses[0]   //return public IP ,addresses[1] return private ip
    }
    
    
    public static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
        
    }
//    func Q6IOSClientPost(ActionName: String ,Paramter:String) -> AnyObject
//    {
//        
//        
//        return 4
//    }
//    func ConvertJsonToDictionaryData(jsonData: AnyObject?)-> [String:String]
//    {
//        var decoded:[String:String]?
//        do {
//            decoded = try NSJSONSerialization.JSONObjectWithData(jsonData as! NSData, options: []) as? [String:String]
//            // here "decoded" is the dictionary decoded from JSON data
//            
//        
//        } catch let error as NSError {
//            print(error)
//        }
//        return decoded!
//    }
    
        
        
  
    func Q6Login(){
        
        var dicData=[String:String]()
        dicData["WebApiTOKEN"]="91561308-B547-4B4E-8289-D5F0B23F0037"
             dicData["LoginUserName"]="yange@uniware.com.au"
          dicData["Password"]="richman58."
          dicData["ClientIP"]="127.0.0.1"
        
     
        
       var ddddd =  Q6IosClientPostAPI("InternalUserLogin", dicData:dicData)
        var error: NSError?
        var jsonData: String?
      
       jsonData = convertDictionaryToJSONData(dicData)
        
     var dd = convertJSONToDictionary(jsonData)
        
        // create the request & response
        var request = NSMutableURLRequest(URL: NSURL(string: "http://api.q6.com.au/api/Q6/InternalUserLogin")!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        var response: NSURLResponse?
      
        var json: Array<Any>!

        // create some JSON data and configure the request
        let jsonString = "{'WebApiTOKEN': '91561308-B547-4B4E-8289-D5F0B23F0037','LoginUserName': 'yange@uniware.com.au','Password': 'richman58.','ClientIP':'127.0.0.1'}"
        request.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let newPost: NSDictionary = ["title": "Frist Psot", "body": "I iz fisrt", "userId": 1]
        do {
           // let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
           // postsUrlRequest.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)//jsonPost
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) in
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    print(error)
                    return
                }
                var dictionary: [String:Int]
                // parse the result as JSON, since that's what the API provides
                var post:AnyObject
                do {
                    post = try  NSJSONSerialization.JSONObjectWithData(responseData, options: [])
                } catch  {
                    print("error parsing response from POST on /posts")
                    return
                }
                var dd = post as! NSDictionary
                
                var ddd = dd["IsSuccessed"] as! Bool
//                // now we have the post, let's just print it to prove we can access it
//                print("The post is: " + post.description)
//                
//              var dd =   post["IsSuccessed"]
//                // the post object is a dictionary
//                // so we just access the title using the "title" key
//                // so check for a title and print it if we have one
//                if let ActionCode = post["ActionCode"] as? String
//                {
//                    print("The ActionCode is: \(ActionCode)")
//                }
//                
//                if let isSuccessed = post["IsSuccessed"] as? String
//                {
//                    print("The isSuccessed is: \(isSuccessed)")
//                }
//                if let message = post["Message"] as? String
//                {
//                    print("The Message is: \(message)")
//                }
//                if let returnValue = post["ReturnValue"] as? Dictionary<String,String>
//                {
//                    print("The Message is: \(returnValue)")
//                     print("The Message is: \(returnValue["CompanyID"])")
//                }
            })
            task.resume()
        }
//        
//        do {
//            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
//            
//           
//            
//            do {
//                json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? Array
//            } catch {
//                print(error)
//            }
//            
//            if let item = json[0] as? [String: AnyObject] {
//                if let person = item["person"] as? [String: AnyObject] {
//                    if let age = person["age"] as? Int {
//                        print("Dani's age is \(age)")
//                    }
//                }
//            }
//            
//        } catch (let e) {
//            print(e)
//        }
//        // look at the response
//        if let httpResponse = response as? NSHTTPURLResponse {
//            print("HTTP response: \(httpResponse.statusCode)")
//        } else {
//            print("No HTTP response")
//        }
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