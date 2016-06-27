//
//  PurchaseTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 22/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SendEmailButton: UIButton!
 
    @IBOutlet weak var lblSendEmail: UILabel!
    @IBOutlet weak var lblSubTotalAmount: UILabel!
    @IBOutlet weak var lblMemo: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var CustomerButton: UIButton!
    @IBOutlet weak var SalesTypeButton: UIButton!
    @IBOutlet weak var lblAddImageLabel: UILabel!
    @IBOutlet weak var AddRemoveImageButton: UIButton!
    @IBOutlet weak var LineDescription: UILabel!
    @IBOutlet weak var AddDeleteButton: UIButton!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblSalesType: UILabel!
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
