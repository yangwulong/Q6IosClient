//
//  PurchaseTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 22/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSupplierName: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
