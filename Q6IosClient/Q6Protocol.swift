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
    
    func  sendGoBackFromView(fromView : String ,forCell: String,selectedValue : String)
}
