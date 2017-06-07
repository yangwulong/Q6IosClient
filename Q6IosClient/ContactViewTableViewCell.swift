//
//  ContactViewTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 15/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class ContactViewTableViewCell: UITableViewCell {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnCallButton: UIButton!
    @IBOutlet weak var lblMemo: UITextView!
    @IBOutlet weak var txtContactName: UITextField!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var txtDueDate: UITextField!
    @IBOutlet weak var btnDueDate: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
