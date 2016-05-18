//
//  Q6Extension.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
import UIKit
extension CALayer {
    
    func addBorder(SelfWidth: CGFloat, edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        var border = CALayer()
    
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, SelfWidth, thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }
        
        border.backgroundColor = color.CGColor;
        
        self.addSublayer(border)
    }
    
}


extension String {
    var length: Int {
        return characters.count
    }
    
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    
    func toDateTime() -> NSDate?
    {
        //Create Date Formatter
        let dateFormatter = NSDateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        //Parse into NSDate
        
       var str = self
      var seperateStr = str.componentsSeparatedByString("T")
        if let dateFromString : NSDate = dateFormatter.dateFromString(seperateStr[0]){
            
            return dateFromString
        }
        else {
            return nil
        }
     
      
        

    }
}

extension NSDate {
    var formatted:String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en_AU")
        
//        var todaysDate:NSDate = NSDate()
//        var dateFormatter:NSDateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
        var convertDate = formatter.stringFromDate(self)
        
        return convertDate
}
}

