//
//  Q6Protocol.swift
//  Q6IosClient
//
//  Created by yang wulong on 21/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation


protocol Q6WebApiProtocol : class {    // 'class' means only class types can implement it
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    
}

protocol Q6GoBackFromView :class {
    
    func  sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String)
   
    func  sendGoBackFromContactSearchView(fromView : String ,forCell: String,Contact: Supplier)
    
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
    
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetail: PurchasesTransactionsDetail)
    
        func sendGoBackFromPreLoadInventoryPurchaseView(fromView:String,forCell:String,preLoadInventoryPurchase: PreLoadInventoryPurchase)
    
       func  sendGoBackFromPurchaseDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
     func  sendGoBackFromPurchaseDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    
     func  sendGoBackFromPurchaseDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    
}
