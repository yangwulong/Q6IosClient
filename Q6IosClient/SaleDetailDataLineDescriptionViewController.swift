//
//  SaleDetailDataLineDescriptionViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 14/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailDataLineDescriptionViewController: UIViewController ,UITextViewDelegate{

    @IBOutlet weak var descriptionTextView: UITextView!
    var fromCell = String()
    weak var delegate : Q6GoBackFromView?
    var strDescription = String()
    
    var textValue = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        if textValue != ""
        {
            descriptionTextView.text = textValue
            descriptionTextView.textColor = UIColor.black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        // descriptionTextView.becomeFirstResponder()
        //descriptionTextView.text = "ffffddddddddd"
        setControlAppear()
        //descriptionTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        if textValue != ""
        {
            descriptionTextView.text = textValue
        }
        
    }
    
    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        if descriptionTextView.textColor == UIColor.lightGray
        {
            strDescription = ""
        }
        else {
            strDescription = descriptionTextView.text
        }
        
        self.delegate?.sendGoBackFromSaleDetailDataLineDescriptionView(fromView: "SaleDetailDataLineDescriptionViewController", forCell: "DescriptionCell", Description: strDescription)
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    func setControlAppear()
    {
        let strDescription = descriptionTextView.text
        
        if strDescription == "" {
            
            
            
            
            descriptionTextView.text = "Description"
            descriptionTextView.textColor = UIColor.lightGray
        }
        //
        //        descriptionTextView.selectedTextRange = descriptionTextView.textRangeFromPosition(descriptionTextView.beginningOfDocument, toPosition: descriptionTextView.beginningOfDocument)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && textView.text == "Description" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
        
        descriptionTextView.selectedTextRange = descriptionTextView .textRange(from: descriptionTextView.beginningOfDocument, to: descriptionTextView.beginningOfDocument)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //        if textView.text.isEmpty {
        //            textView.text = "Description"
        //            textView.textColor = UIColor.lightGrayColor()
        //        }
    }
    
    //    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    //
    //        // Combine the textView text and the replacement text to
    //        // create the updated text string
    //        let currentText:NSString = descriptionTextView.text
    //        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
    //
    //        // If updated text view will be empty, add the placeholder
    //        // and set the cursor to the beginning of the text view
    //        if updatedText.isEmpty {
    //
    //            textView.text = "Description"
    //            textView.textColor = UIColor.lightGrayColor()
    //
    //           textView.selectedTextRange = descriptionTextView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
    //
    //            return false
    //        }
    //
    //            // Else if the text view's placeholder is showing and the
    //            // length of the replacement string is greater than 0, clear
    //            // the text view and set its color to black to prepare for
    //            // the user's entry
    //        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
    //            textView.text = ""
    //            textView.textColor = UIColor.blackColor()
    //        }
    //
    //        return true
    //    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        //        if self.view.window != nil {
        //           // print("textView 's length" + textView.text.length.description)
        //            if textView.textColor == UIColor.lightGrayColor() {
        //                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        //            }
        //        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
