//
//  SaleDetailDataLineTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 14/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailDataLineTableViewCell: UITableViewCell {

    @IBOutlet weak var taxCodeButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    
    @IBOutlet weak var lblInventoryName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblQuantity: UITextField!
    @IBOutlet weak var lblUnitPrice: UITextField!
    @IBOutlet weak var lblTaxCodeName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblAccountNameWithNo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
