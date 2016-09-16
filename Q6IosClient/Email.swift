//
//  Email.swift
//  Q6IosClient
//
//  Created by yang wulong on 17/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation


public class Email
{
    var TransactionID =  NSUUID().uuidString
    var SenderName: String = ""
    var FromEmail: String = ""
    var ToEmail: String = ""
    var CcEmail:String?
    var BccEmail:String?
    var SubjectName: String = ""
    var BodyMessage: String = ""
    var ModuleName:String = "Sale"
    var SendMeACopy:Bool = false
}
