//
//  PurchaseDetailTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 3/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblSupplierName: UILabel!
    @IBOutlet weak var lblPurchasesType: UILabel!
    @IBOutlet weak var lblTotalAmountLabel: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
