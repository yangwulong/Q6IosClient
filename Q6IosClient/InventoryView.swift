//
//  InventoryView.swift
//  Q6IosClient
//
//  Created by yang wulong on 12/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
public class InventoryView {
    
    var InventoryID = String()
    var InventoryName = String()
    var Inventorytype = String()
    var IsBuy = Bool()
    var IsSell = Bool()
    var IsInventory = Bool()
    var IsInactive = Bool()
    var SupplierPartNumber = String()
    var CategoryName = String()
    var AssetAccountNameWithAccountNo = String()
    var PurchaseDescription = String()
    var PurchasePrice:Double?
    var IsPurchasePriceTaxInclusive = Bool()
    var PurchaseAccountNameWithAccountNo = String()
    var PurchaseTaxCodeName = String()
    var MinQuantityForRestockingAlert:Double?
    var SaleDescription = String()
    var SellingPrice:Double?
    var IsSalePriceTaxInclusive = Bool()
    var SaleTaxCodeName = String()
    var SaleAccountNameWithAccountNo = String()
    var SupplierName = String()
    var  QuantityOnHand = Double()
    var CurrentValue = Double()
    var  AverageCost = Double()
    var Committed = Double()
    var OnOrder = Double()
    var Available = Double()
    var AssetAccountID:String?
    var PurchaseAccountID:String?
    var SaleAccountID:String?
    var PurchaseTaxCodeID:String?
    var PurchaseTaxCodeRate:Double?
    var PurchaseTaxCodePurpose:String?
    var SaleTaxCodeID:String?
    var SaleTaxCodeRate:Double?
    var SaleTaxCodePurpose:String?
    
}
