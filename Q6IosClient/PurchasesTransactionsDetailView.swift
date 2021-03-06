//
//  PurchasesTransactionsDetailView.swift
//  Q6IosClient
//
//  Created by yang wulong on 12/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
public class PurchasesTransactionsDetailView
{
    
    var PurchasesTransactionsDetailID  = NSUUID().uuidString //:String =  NSUUID().uuidString
    var PurchasesTransactionsHeaderID = NSUUID().uuidString
    var Quantity:Double = 0
    var InventoryID:String?
    var InventoryName: String = ""
    var AccountID:String?
    var AccountNameWithAccountNo:String = ""
    var TaxCodeID:String?
    var TaxCodeName = String()
    var TaxCodeRate:Double?
    var Description: String = ""
    var UnitPrice:Double = 0
    var Discount:Double?
    var AmountWithoutTax: Double = 0
    var Amount: Double = 0
    var IsDeleted: Bool = false 
    var SortNo = Int()
    
}
