//
//  SalesTransactionsHeader.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
public class SalesTransactionsHeader
{
    
    var SalesTransactionsHeaderID  = NSUUID().UUIDString //: String = NSUUID().UUIDString
    var ClosedDate = NSDate?()
    var CreateTime = NSDate()
    var CustomerID = String()
    
    var CustomerPurchaseNO: String = ""
    var DueDate = NSDate?()
    var HasLinkedDoc = Bool()
    var IsCreatedByRecurring = Bool()
    var IsDeleted = Bool()
    var LastModifiedTime = String()
    var Memo :String = ""
    var RecurringTemplateID = String?()
    
    
    var ReferenceNo = String()
    var SalesStatus :String = "Open"
    var SalesType: String = "Invoice"
    var ShipToAddress = String()
    var SubTotal = Double()
    var TaxTotal = Double()
    var TaxInclusive: Bool = true
    var TotalAmount = Double()
    var TransactionDate = NSDate()
 
    
  
    
   
   
    
    
   
    
   
   
   
    
    
    
}