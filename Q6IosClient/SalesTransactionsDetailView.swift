//
//  SalesTransactionsDetailView.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
public class SalesTransactionsDetailView
{
    
    var SalesTransactionsDetailID  = NSUUID().UUIDString //:String =  NSUUID().UUIDString
    var SalesTransactionsHeaderID = NSUUID().UUIDString
    var Quantity:Double = 0
    var InventoryID = String?()
    var InventoryName: String = ""
    var AccountID = String?()
    var AccountNameWithAccountNo:String = ""
    var TaxCodeID = String?()
    var TaxCodeName = String()
    var TaxCodeRate = Double?()
    var Description: String = ""
    var UnitPrice:Double = 0
    var Discount :Double = 0
    var AmountWithoutTax: Double = 0
    var Amount: Double = 0
    var IsDeleted: Bool = false
    var SortNo = Int()
    
}