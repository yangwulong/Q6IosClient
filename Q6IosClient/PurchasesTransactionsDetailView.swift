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
    
    var PurchasesTransactionsDetailID = String()
    var PurchasesTransactionsHeaderID = String()
    var Quantity:Double = 0
    var InventoryID = String?()
    var InventoryNameWithInventoryNO: String = ""
    var AccountID = String?()
    var AccountNameWithAccountNo:String = ""
    var TaxCodeID = String?()
    var TaxCodeName = String()
    var TaxRate = Double()
    var Description: String = ""
    var UnitPrice:Double = 0
    var Discount = Double?()
    var Amount: Double = 0
    var IsDeleted = Bool()
    var SortNo = Int()
    
}