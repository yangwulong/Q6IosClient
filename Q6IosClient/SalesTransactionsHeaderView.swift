//
//  SalesTransactionsHeaderView.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation

public class SalesTransactionsHeaderView
{
    
    var SalesTransactionsHeaderID  = NSUUID().uuidString //: String = NSUUID().uuidString
    var ReferenceNo = String()
    var SalesType: String = "Invoice"
    var SalesStatus = String()
    var TransactionDate = NSDate()
    var CreateTime = NSDate()
    var LastModifiedTime = String()
    var CustomerID = String()
    var ShipToAddress = String()
    var SupplierInv = String()
    var Memo :String = ""
    var ClosedDate:NSDate?
    var SubTotal = Double()
    var TaxTotal = Double()
    var TotalAmount = Double()
    var DueDate:NSDate?
    var TaxInclusive: Bool = true
    var IsDeleted = Bool()
    var IsCreatedByRecurring = Bool()
    var RecurringTemplateID:String?
    var HasLinkedDoc = Bool()
    
    var CustomerName = String()
    
    
    var UploadedDocumentsID:String?
    var LinkDocumentFileName:String?
    var LinkDocumentFileSize:Double?
    var LinkDocumentFile:String?
    
    
    
    
}
