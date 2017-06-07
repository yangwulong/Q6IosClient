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
        
        let border = CALayer()
    
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x:0, y:0, width:self.frame.height, height:thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:SelfWidth, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width:thickness, height:self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.width - thickness, y:0, width:thickness, height:self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
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
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        //Parse into NSDate
        
       let str = self
      var seperateStr = str.components(separatedBy: "T")
   
        if let dateFromString : NSDate = dateFormatter.date(from: seperateStr[0]) as NSDate?{
            
            return dateFromString
        }
        else {
            return nil
        }
    }
    
    subscript (index: Int) -> Character {
        let charIndex = self.index(after: self.startIndex)
        return self[charIndex]
    }
    
}

extension NSDate {
    
    private var formatter: DateFormatter {
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = NSLocale(localeIdentifier: "en_AU") as Locale!
        
        return formatter
    }
    
    var formatted:String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yyyy"
//        formatter.locale = NSLocale(localeIdentifier: "en_AU") as Locale!
        
//        var todaysDate:NSDate = NSDate()
//        var dateFormatter:NSDateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy"
        let convertDate = formatter.string(from: self as Date)
        
        return convertDate
    }
    
    func isLaterOrEqualThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreaterOrEqual = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreaterOrEqual = true
        }
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isGreaterOrEqual = true
        }
        
        //Return Result
        return isGreaterOrEqual
    }
    
    func getMonth() -> Int {
        
        let calendar = NSCalendar.current
        
        //这里注意 swift要用[,]这样方式写
        
        let com = calendar.dateComponents([.year,. month, .day], from: self as Date)
        
        return com.month ?? 0
    }
    
    func getYear() -> Int {
        
        let calendar = NSCalendar.current
        
        //这里注意 swift要用[,]这样方式写
        
        let com = calendar.dateComponents([.year,. month, .day], from: self as Date)
        
        return com.year ?? 0
    }
    
    
}

