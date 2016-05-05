//
//  PurchasesTransactionsHeader.swift
//  Q6IosClient
//
//  Created by yang wulong on 2/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation

public class PurchasesTransactionsHeader
{
    
    var PurchasesTransactionsHeaderID = String()
    var ReferenceNo = String()
    var PurchasesType: String = "BILL"
    var PurchasesStatus = String()
    var TransactionDate = NSDate()
    var CreateTime = NSDate()
    var LastModifiedTime = NSDate()
    var SupplierID = String()
    var ShipToAddress = String()
    var SupplierInv = String()
    var Memo = String?()
    var ClosedDate = NSDate?()
    var SubTotal = Double()
    var TaxTotal = Double()
    var DueDate = NSDate?()
    var TaxInclusive = Bool()
    var IsDeleted = Bool()
    var IsCreatedByRecurring = Bool()
    var RecurringTemplateID = String?()
    var HasLinkedDoc = Bool()
    
   
}