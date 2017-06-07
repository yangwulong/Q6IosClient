//
//  SendEmailTableViewCell.swift
//  Q6IosClient
//
//  Created by yang wulong on 17/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SendEmailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var txtSubject: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func FromEditingChanged(sender: AnyObject) {
    }
    @IBAction func ToEditingChanged(sender: AnyObject) {
    }
    @IBOutlet weak var SubjectEditingChanged: UITextField!
}
