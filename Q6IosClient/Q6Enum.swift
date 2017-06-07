//
//  Q6Enum.swift
//  Q6IosClient
//
//  Created by admin on 2017/5/31.
//  Copyright © 2017年 q6. All rights reserved.
//

import UIKit

public enum DueDateType: Int {
    case ofTheFollowingMonth = 1
    case daysAfterTheInvoiceDate
    case daysAfterTheEndOfTheInvoiceMonth
    case ofTheCurrentMonth
}
