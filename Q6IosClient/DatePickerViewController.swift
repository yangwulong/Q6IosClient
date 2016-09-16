//
//  DatePickerViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    
    var selectedDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDate = datePicker.date as NSDate
        if( fromCell == "DueDateCell")
        {

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func datePickerValueChanged(sender: AnyObject) {
        
        let date = datePicker.date
        
        //print(date.formatted)
    }
  
    
    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
         _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
 selectedDate = datePicker.date as NSDate
        
    
        
        self.delegate?.sendGoBackFromDatePickerView(fromView: "DatePickerViewController", forCell: fromCell, Date: selectedDate)
        _ = navigationController?.popViewController(animated: true)
        // navigationController?.popToRootViewControllerAnimated(true)
   
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
