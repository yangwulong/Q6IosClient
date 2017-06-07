//
//  ContactSearchViewTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 15/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactSearchViewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblContactID: UILabel!
    @IBOutlet weak var lblContactName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
