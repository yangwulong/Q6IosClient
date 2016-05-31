//
//  PurchasesTransactionsDetail.swift
//  Q6IosClient
//
//  Created by yang wulong on 2/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation

public class PurchasesTransactionsDetail
{

    var PurchasesTransactionsDetailID = NSUUID()
    var PurchasesTransactionsHeaderID = NSUUID()
    var Quantity = Double()
    var InventoryID = String?()
    var AccountID = String?()
    var TaxCodeID = String?()
    var Description = String?()
    var UnitPrice = Double()
    var Discount = Double?()
    var Amount = Double()
    var IsDeleted: Bool = false 
    var SortNo = Int()
    
}