//
//  Q6PublicMethod.swift
//  Q6IosClient
//
//  Created by admin on 2017/6/2.
//  Copyright © 2017年 q6. All rights reserved.
//

import UIKit

func ofTheCurrentMonth(days: Int, transactionDate: NSDate) -> NSDate? {
    
    let calendar = Calendar.current
    
    var components = calendar.dateComponents([.year, .month, .day], from: transactionDate as Date)
    
    components.day = days
    
    let date = calendar.date(from: components) as NSDate?
    
    print("date: \(String(describing: date))")
    
    return date
}

func ofTheFollowingMonth(days: Int, createDate: NSDate) ->  NSDate? {
    
    return ofTheMonth(day: days, date: createDate)
}

func daysAfterTheInvoiceDate(days: Int, transactionDate: NSDate) -> NSDate {
    
    let dueDate = transactionDate.addingTimeInterval(TimeInterval(60 * 60 * 24 * days))
    
    print("date: \(String(describing: dueDate))")
    
    return dueDate
}

func daysAfterTheEndOfTheInvoiceMonth(days: Int, transactionDate: NSDate) -> NSDate? {
    
    return ofTheMonth(day: days, date: transactionDate)
}

private func ofTheMonth(day: Int, date: NSDate) -> NSDate? {
    
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: date as Date)
    
    components.month = components.month! + 1
    components.day = day
    
    let date = calendar.date(from: components) as NSDate?
    
    print("date: \(String(describing: date))")
    
    return date
}
