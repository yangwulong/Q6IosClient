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
    
     let q6WebApiUrl = "https://api.q6.com.au/api/"
 static let q6WebApiTOKEN = "91561308-B547-4B4E-8289-D5F0B23F0037"
     weak var delegate : Q6WebApiProtocol?
    init(){}
    
    init(myObject: LoginViewController){
      
        self.delegate = myObject
    }
    

    init(myObject: PurchaseViewController){
        
        self.delegate = myObject
    }
    
    init(myObject: SupplierSearchViewController){
        
        self.delegate = myObject
    }
    init(myObject: PurchaseDetailDataLineInventorySearchViewController){
        
        self.delegate = myObject
    }
    
    
    init(myObject: PurchaseDetailDataLineTaxCodeSearchViewController){
        
        self.delegate = myObject
    }
    
    init(myObject: PurchaseDetailDataLineAccountSearchViewController){
        
        self.delegate = myObject
    }
    
    init(myObject: PurchaseDetailViewController){
        
        self.delegate = myObject
    }
    
    init(myObject: SalesViewController){
        
        self.delegate = myObject
    }
    
    init(myObject: SaleDetailViewController){
        
        self.delegate = myObject
    }
    init(myObject: CustomerSearchViewController){
        
        self.delegate = myObject
    }
    init(myObject: SaleDetailDataLineInventorySearchViewController){
        
        self.delegate = myObject
    }
  
    init(myObject: SaleDetailDataLineAccountSearchViewController){
        
        self.delegate = myObject
    }
    
    init(myObject: SaleDetailDataLineTaxCodeSearchViewController){
        
        self.delegate = myObject
    }
    
  
    init(myObject: ContactSearchViewController){
        
        self.delegate = myObject
    }
    init(myObject: ContactViewController){
        
        self.delegate = myObject
    }
    
    init(myObject: SendEmailViewController){
        
        self.delegate = myObject
    }
    func validateIfTouchIDExist()->Bool{
        
        let context = LAContext()
        
        var error: NSError?
        
    
        if context.canEvaluatePolicy(
            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
            error: &error) {
                return true
        }
        else{
            return false
            
        }
    }
    
    func  validateIfPassCodeExist() -> Bool {
        let secret = "Device has passcode set?".data(using: String.Encoding.utf8, allowLossyConversion: false)
        let attributes = [kSecClass as String:kSecClassGenericPassword, kSecAttrService as String:"LocalDeviceServices", kSecAttrAccount as String:"NoAccount", kSecValueData as String:secret!, kSecAttrAccessible as String:kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly] as [String : Any]
        
        let status = SecItemAdd(attributes as CFDictionary, nil)
        if status == 0 {
            SecItemDelete(attributes as CFDictionary)
            return true
        }
        
        return false
    }
    func convertJSONToDictionary(text: String?) -> [String:AnyObject]? {
        if let data = text!.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
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
            
            let jsonData = try JSONSerialization.data(withJSONObject: dicData, options: [])
            
            let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            returnString = jsonString
            
//      print(jsonString)
//          returnString = jsonString.stringByReplacingOccurrencesOfString("\\",  withString:"")
//                
//        print(returnString)
       }catch{
            
        }
        
        
        return returnString
    }

    func Q6IosClientGetApi(ModelName: String ,ActionName: String ,attachedURL: String)
    {
        
        let q6DBLib =  Q6DBLib()
        var userInfos = q6DBLib.getUserInfos()
        
       
        var loginDetail = [String:String]()
        loginDetail["CompanyID"] = userInfos["CompanyID"]
        loginDetail["Email"] = userInfos["LoginEmail"]
        loginDetail["Password"] = userInfos["PassWord"]
        loginDetail["WebApiTOKEN"] = "91561308-B547-4B4E-8289-D5F0B23F0037"
        
        let jasonLoginDeail = convertDictionaryToJSONData(dicData: loginDetail as [String : AnyObject])
        
        
       let EncodeAttachedURL = (jasonLoginDeail + attachedURL).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed )! as String
   // print("EncodeAttachedURL \(EncodeAttachedURL)")
        
        
        let url : String = q6WebApiUrl + ModelName + "/" + ActionName + "?Jsonlogin="  + EncodeAttachedURL
       // var url : String = q6WebApiUrl + ModelName + "/" + ActionName + "?Jsonlogin=" + jasonLoginDeail + attachedURL
        let configuration = URLSessionConfiguration .default
        let session = URLSession(configuration: configuration)
        
        
        let urlString : String = url.replacingOccurrences(of: "\\", with: "") as String
  //  print(" Original urlString: \(urlString)")
//      urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//        
//        
//       print("urlString: \(urlString)")
//        
//       urlString = url.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
//    
// print("2 urlString: \(urlString)")
        
        //let url = NSURL(string: urlString as String)
        let request : NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: urlString )! as URL)
       // request.URL = NSURL(string:urlString ) //NSURL(string: NSString(format: "%@", urlString) as String)
        
    
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let dataTask = session.dataTask(with: request as URLRequest) {
            ( data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
            guard error == nil else {
                print("error calling GET on /posts/1")
                print(error)
                return
            }
            guard response != nil else {
                print("error calling response")
                print(error)
                return
            }
            
            // 1: Check HTTP Response for successful GET request
            guard let httpResponse = response as? HTTPURLResponse, let _ = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
            guard case httpResponse.statusCode = 200 else {
                
                print("error: status is not 200")
                return
            }
            
            self.completion(data: data as NSData?, response: response, error: error as NSError?)
//            switch (httpResponse.statusCode)
//            {
//            case 200:
//                
//                let response = NSString (data: receivedData, encoding: NSUTF8StringEncoding)
//                print("response is \(response)")
//                
//                
//                do {
//                    let getResponse = try NSJSONSerialization.JSONObjectWithData(receivedData, options: .AllowFragments)
//                    
//                  //  EZLoadingActivity .hide()
//                    
//                    // }
//                } catch {
//                    print("error serializing JSON: \(error)")
//                }
//                
//                break
//            case 400:
//                
//                break
//            default:
//                print("wallet GET request got response \(httpResponse.statusCode)")
           // }
        }
        dataTask.resume()
    }
    func Q6IosClientPostAPI(ModeName: String ,ActionName: String, dicData:[String:AnyObject]){
        
        let UrlString = q6WebApiUrl + ModeName + "/"  + ActionName;
        
        
        // create the request & response
        let request = NSMutableURLRequest(url: NSURL(string: UrlString)! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5)
      //  var response: NSURLResponse?
        
        
        
        // create some JSON data and configure the request
        let jsonString = convertDictionaryToJSONData(dicData: dicData)
        
       print(jsonString)
        request.httpBody = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        

        do {
            // let jsonPost = try NSJSONSerialization.dataWithJSONObject(newPost, options: [])
            // postsUrlRequest.HTTPBody = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)//jsonPost
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
         
  
            
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error)  in
                guard data != nil else {
                    print("Error: did not receive data")
                    return
                }
                guard error == nil else {
                    print("error calling GET on /posts/1")
                    print(error)
                    return
                }
                guard response != nil else {
                    print("error calling response")
                    print(error)
                    return
                }
           
       
                self.completion(data: data as NSData?, response: response, error: error as NSError?)
                // parse the result as JSON, since that's what the API provides
       
             

            })
            
            
            task.resume()
//
            
           
        }
    
    }

 
   public func completion(data:NSData?, response:URLResponse?, error:NSError?) {
        
        self.delegate?.dataLoadCompletion(data: data, response: response, error: error)
     
        
    }
    
    
    
    public static func isEmailAddressValid(email: String) -> Bool {
        
        var filterString: String
        
        filterString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
     
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", filterString)
        
        return emailTest.evaluate(with: email)
    }
    
    public static func q6UIAlertPopupController(title: String?,message:String?,viewController: AnyObject?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
       viewController!.present(alert, animated: true, completion: nil)
        
      
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        
 
        

        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
            
     
            if  let v = viewController  {
                viewController?.dismiss(animated: true, completion: nil)
            }
 
            
            // self.navigationController!.popViewControllerAnimated(true)
            // self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//                                      Int64(1 * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            viewController!.dismissViewControllerAnimated(true, completion: nil);
//        }
    }
    
    public static func q6UIAlertPopupController(title: String?,message:String?,viewController: AnyObject? ,timeArrange: Double)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        viewController!.present(alert, animated: true, completion: nil)
        
        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//                                      Int64(timeArrange * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            viewController!.dismissViewControllerAnimated(true, completion: nil);
//        }
        
        
        let delayTime = DispatchTime.now() + Double(Int64(timeArrange * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        
        
        //                let delayTime = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),
        //                                              Int64(3 * Double(NSEC_PER_SEC)))
        //                let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
        //                                               Int64(4 * Double(NSEC_PER_SEC)))
        
        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
            
            if  let v = viewController  {
                viewController?.dismiss(animated: true, completion: nil)
            }
        
            // self.navigationController!.popViewControllerAnimated(true)
            // self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    public static func q6UIAlertPopupControllerThenGoBack(title: String?,message:String?,viewController: AnyObject? ,timeArrange: Double ,navigationController: UINavigationController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        viewController!.present(alert, animated: true, completion: nil)
        
        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
//                                      Int64(timeArrange * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            viewController!.dismissViewControllerAnimated(true, completion: nil);
//             navigationController.popViewControllerAnimated(true)
//        }
        
        
        let delayTime = DispatchTime.now() + Double(Int64(timeArrange * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
 
        
        //                let delayTime = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW),
        //                                              Int64(3 * Double(NSEC_PER_SEC)))
        //                let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
        //                                               Int64(4 * Double(NSEC_PER_SEC)))
        
        DispatchQueue.main.asyncAfter(deadline: delayTime)
        {
          //viewController?.dismiss(animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
         viewController!.dismiss(animated:true, completion: nil);
            navigationController.popViewController(animated: true)
        }
    }
    
    // changed return from [String] to String
     //addresses[0] return public IP ,addresses[1] return private ip
    static func getIPAddresses() -> String {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            repeat{
               
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                                var addr = ptr?.pointee.ifa_addr.pointee
                
                                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                                    if addr?.sa_family == UInt8(AF_INET) || addr?.sa_family == UInt8(AF_INET6) {
                
                                        // Convert interface address to a human readable string:
                                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                                        if (getnameinfo(&addr!, socklen_t((addr?.sa_len)!), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                            
                                   //String(
                                            if let address = String(validatingUTF8: hostname) {
                                                addresses.append(address)
                                            }
                                        }
                                    }
                                }
                ptr = ptr?.pointee.ifa_next

            }while (ptr != nil)
//            // For each interface ...
//            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
//                let flags = Int32(ptr.memory.ifa_flags)
//                var addr = ptr.memory.ifa_addr.memory
//                
//                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
//                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
//                        
//                        // Convert interface address to a human readable string:
//                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
//                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                            if let address = String.fromCString(hostname) {
//                                addresses.append(address)
//                            }
//                        }
//                    }
//                }
//            }
            freeifaddrs(ifaddr)
        }
        return addresses[0]   //return public IP ,addresses[1] return private ip
    }
    
    
    public static func isConnectedToNetwork() -> Bool {
        
//        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
//        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        
//        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
//        }
//        
//        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
//        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
//            return false
//        }
//        
//        let isReachable = flags == .Reachable
//        let needsConnection = flags == .ConnectionRequired
//        
//        return isReachable && !needsConnection
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
//        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
//            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
//        }
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    
//
    }
    
    public static func getQ6WebAPIToken() -> String
    {
        return q6WebApiTOKEN
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
    
        
        
  
    
//    func testTouchID()->(msg:String,err:String) {
//        
//        var msg: String = ""
//        var err: String = ""
//        let context = LAContext()
//        
//        var error: Error?
//        
//        if context.canEvaluatePolicy(
//            LAPolicy.deviceOwnerAuthenticationWithBiometrics,
//            error: &error) {
//                
//                context.evaluatePolicy(
//                    LAPolicy.deviceOwnerAuthenticationWithBiometrics,
//                    localizedReason: "Access requires authentication",
//                    reply: {(success, error) in
//                  DispatchQueue.main.async {
//                            
//                            if error != nil {
//                                
//                                switch error! {
//                                    
//                                case LAError.SystemCancel.rawValue:
//                                  
//                                    msg = "Session cancelled"
//                                    err = (error?.localizedDescription)!
//                                  
//                                    
//                                case LAError.UserCancel.rawValue:
//                                 
//                           
//                                     msg = "Please try again"
//                                     err = (error?.localizedDescription)!
//                                    
//                                case LAError.UserFallback.rawValue:
//                       
//                                    // Custom code to obtain password here
//                                    msg = "Authentication"
//                                    err = "Password option selected"
//                                    
//                                default:
//                           
//                                    msg = "Authentication failed"
//                                    err = (error?.localizedDescription)!
//                                }
//                                
//                            } else {
//                       
//                                msg = "Authentication Successful"
//                                err = "You now have full access"
//                            }
//                        }
//                })
//                
//                
//        } else {
//            // Device cannot use TouchID
//            switch error!.code{
//                
//            case LAError.TouchIDNotEnrolled.rawValue:
//                notifyUser("TouchID is not enrolled",
//                    err: error?.localizedDescription)
//                msg = "TouchID is not enrolled"
//                err = (error?.localizedDescription)!
//                
//            case LAError.PasscodeNotSet.rawValue:
//          
//                msg = "A passcode has not been set"
//                err = (error?.localizedDescription)!
//                
//            default:
//      
//                
//                msg = "TouchID not available"
//                err = (error?.localizedDescription)!
//                
//            }
//        }
//        return (msg ,err)
//    }
    
    public static func popUpLoadingSign(parentView: UIViewController) {
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        myActivityIndicator.center = parentView.view.center
        myActivityIndicator.startAnimating()
        parentView.view.addSubview(myActivityIndicator)
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
