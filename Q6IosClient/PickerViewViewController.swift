//
//  PickerViewViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 4/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PickerViewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    @IBOutlet weak var lblPickerViewDescription: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    var pickerDataSource = [String]()
    override func viewWillAppear(_ animated: Bool) {
        //  self.view.transform = CGAffineTransformMakeTranslation(600, 0)
        
        if( fromCell == "PurchasesTypecell")
        {
            lblPickerViewDescription.text = "Please select a Purchase Type!"
            pickerDataSource = ["Quote","Order","Bill","DebitNote"]
        }
        if( fromCell == "SalesTypecell")
        {
            lblPickerViewDescription.text = "Please select a Sale Type!"
            pickerDataSource = ["Quote","Order","Invoice","CreditNote"]
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        print("from cell" + fromCell)
        
        
    }
    @IBAction func CancelButtonClick(sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
        
        // navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func DonebuttonClick(sender: AnyObject) {
        let selectedValue = pickerDataSource[pickerView.selectedRow(inComponent: 0)]
        
        self.delegate?.sendGoBackFromPickerView(fromView: "fromPickerViewViewController" ,forCell :fromCell,selectedValue: selectedValue)
        
        _ = navigationController?.popViewController(animated: true)
        // navigationController?.popToRootViewControllerAnimated(true)
        print("PickView selected row" + selectedValue)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("row" + row.description)
        return pickerDataSource[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
