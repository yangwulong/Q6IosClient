//
//  MasterViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 17/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit
import LocalAuthentication


//protocol testProtocol : class {    // 'class' means only class types can implement it
//    func searchQueryData() -> String
//}

//public class TestMasterClass: testProtocol{
//    
//    func searchQueryData() -> String {
//        
//        
//        return "Master"
//    }
//}
//
//public class TestDetailClass{
//     weak var delegate : testProtocol?
//    
//    init(parentClass: MasterViewController)
//    {
//       self.delegate = parentClass
//    }
//    func doSomethingWhenTapped() {
//        
//       var parentSearchData = delegate?.searchQueryData()
//    }
//    
//}
class MasterViewController: UITableViewController, Q6WebApiProtocol{

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dd = Q6CommonLib(myObject: self)
        
        
        var dicData=[String:String]()
        dicData["WebApiTOKEN"]="91561308-B547-4B4E-8289-D5F0B23F0037"
        dicData["LoginUserName"]="yange@uniware.com.au"
        dicData["Password"]="richman58."
        dicData["ClientIP"]="127.0.0.1"
        
        dd.Q6IosClientPostAPI("Q6",ActionName: "InternalUserLogin", dicData:dicData)
        

        
               // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }


    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        

     var postDicData :[String:AnyObject]
     var IsLoginSuccessed : Bool
        do {
         postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
          
 
       IsLoginSuccessed = postDicData["IsSuccessed"] as! Bool
       
  
         
            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }
        
        
        return ""
    }
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
  
//    var message =  q6Login.testTouchID()
//    notifyUser(message.msg, err: message.err)
      // testTouchID()
    }

    
    func testTouchID() {
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
                                    self.notifyUser("Session cancelled",
                                        err: error?.localizedDescription)
                                    
                                case LAError.UserCancel.rawValue:
                                    self.notifyUser("Please try again",
                                        err: error?.localizedDescription)
                                    
                                case LAError.UserFallback.rawValue:
                                    self.notifyUser("Authentication",
                                        err: "Password option selected")
                                    // Custom code to obtain password here
                                    
                                default:
                                    self.notifyUser("Authentication failed",
                                        err: error?.localizedDescription)
                                }
                                
                            } else {
                                self.notifyUser("Authentication Successful",
                                    err: "You now have full access")
                            }
                        }
                })
                
                
        } else {
            // Device cannot use TouchID
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                notifyUser("TouchID is not enrolled",
                    err: error?.localizedDescription)
                
            case LAError.PasscodeNotSet.rawValue:
                notifyUser("A passcode has not been set",
                    err: error?.localizedDescription)
                
            default:
                notifyUser("TouchID not available", 
                    err: error?.localizedDescription)
                
            }
        }
    }
    
    func notifyUser(msg: String, err: String?) {
        let alert = UIAlertController(title: msg, 
            message: err, 
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK", 
            style: .Cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, 
            completion: nil)
    }
    
    
override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

