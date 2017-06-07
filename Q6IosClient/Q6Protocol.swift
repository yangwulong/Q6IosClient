//
//  Q6Protocol.swift
//  Q6IosClient
//
//  Created by yang wulong on 21/03/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation
import UIKit

protocol Q6WebApiProtocol : class {    // 'class' means only class types can implement it
    func dataLoadCompletion(data:NSData?, response:URLResponse?, error:NSError?) -> AnyObject
    
}

protocol Q6GoBackFromView :class {
    
    func  sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String)
    
    func  sendGoBackFromSupplierSearchView(fromView : String ,forCell: String,Contact: Supplier)
    
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
    
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetailView: PurchasesTransactionsDetailView)
    
    func sendGoBackFromPurchaseDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView)
    
    func  sendGoBackFromPurchaseDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    func  sendGoBackFromPurchaseDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    
    func  sendGoBackFromPurchaseDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    func sendGoBackFromAddImageView(fromView: String, forCell: String, image:UIImage)
    
    func  sendGoBackFromPurchaseDetailMemoView(fromView : String ,forCell: String,Memo: String)
    
    
    func sendGoBackFromSaleDetailDataLineView(fromView:String,forCell:String,salesTransactionsDetailView: SalesTransactionsDetailView)
    
    func sendGoBackFromSaleDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView)
    
    func  sendGoBackFromSaleDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    func  sendGoBackFromSaleDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    
    func  sendGoBackFromSaleDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)

    
    func  sendGoBackFromSaleDetailMemoView(fromView : String ,forCell: String,Memo: String)
    func  sendGoBackFromCustomerSearchView(fromView : String ,forCell: String,Contact: Customer)
 
    
   
}


protocol Q6GoBackFromViewTwo :class {
func  sendGoBackFromPurchaseDetailView(fromView : String ,fromButton: String)
    func  sendGoBackSaleDetailView(fromView : String ,fromButton: String)
     func  sendGoBackContactDetailView(fromView : String ,fromButton: String)
}




