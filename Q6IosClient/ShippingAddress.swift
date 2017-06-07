//
//  Address.swift
//  Q6IosClient
//
//  Created by yang wulong on 26/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import Foundation

public class ShippingAddress
{
    var  ShippingAddress: String = ""
    var  ShippingAddressLine2: String = ""
    var  ShippingCity: String = ""
    var ShippingCountry: String = ""
    var ShippingPostalCode: String = ""
    var ShippingState: String = ""
    var RealCompanyName: String = ""
    
    
    func getShippingAddressStr() -> String
    {
        
        return RealCompanyName + "\n" + ShippingAddress + "\n" + ShippingAddressLine2 + "\n" + ShippingCity + "\n" +  ShippingState + ShippingPostalCode + "\n" + ShippingCountry
    }
    
}