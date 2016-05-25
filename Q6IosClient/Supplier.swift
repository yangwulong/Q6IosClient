//
//  Supplier.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation

public class Supplier {
    
    var SupplierID = String()
    var SupplierName:String = ""
    var Title = String?()
    var FirstName = String?()
    var LastName = String?()
    var Email = String?()
    var Phone = String?()
    var Fax = String?()
    var Memos = String?()
    var BSBNumber = String?()
    var BankAccountNumber = String?()
    var BankAccountName = String?()
    var StatementText = String?()
    var PaymentMemos = String?()
    var DefaultPurchasesAccountID = String?()
    var DefaultPurchasesAccountNameWithAccountNo = String?()
    var ABN = String?()
    var DefaultPurchasesTaxCodeID = String?()
    var DefaultPurchasesTaxCodeName = String()
    var DefaultPurchasesTaxCodeRate = Double()
    var DefaultPurchasesTaxCodePurpose = String()
    var PhysicalAddress = String?()
    var PhysicalCity = String?()
    var PhysicalState = String?()
    var PhysicalPostalCode = String?()
    var PhysicalCountry = String?()
    var IsSameAsPhysicalAddress = Bool?()
    var PostalAddress = String?()
    var PostalCity = String?()
    var PostalState = String?()
    var PostalPostalCode = String?()
    var PostalCountry = String?()
    var IsSameAsPostalAddress = Bool?()
    var ShippingAddress = String?()
    var ShippingState = String?()
    var ShippingPostalCode = String?()
    var ShippingCountry = String?()
    var IsInactive = Bool()
    
}