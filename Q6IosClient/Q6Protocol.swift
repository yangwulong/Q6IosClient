//
//  Q6Protocol.swift
//  Q6IosClient
//
//  Created by yang wulong on 21/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation


protocol Q6WebApiProtocol : class {    // 'class' means only class types can implement it
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    
}

protocol Q6GoBackFromView :class {
    
    func  sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String)
   
    func  sendGoBackFromContactSearchView(fromView : String ,forCell: String,ContactID : String ,ContactName:String)
    
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
}
