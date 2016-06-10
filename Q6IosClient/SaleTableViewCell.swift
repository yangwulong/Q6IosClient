//
//  SaleTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 9/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
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
