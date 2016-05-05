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
    override func viewWillAppear(animated: Bool) {
    //  self.view.transform = CGAffineTransformMakeTranslation(600, 0)
        
                if( fromCell == "PurchasesTypecell")
                {
                    lblPickerViewDescription.text = "Please select a Purchase Type!"
                    pickerDataSource = ["QUOTE","ORDER","BILL","DEBIT NOTE"]
                }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        print("from cell" + fromCell)
  
//        if( fromCell == "PurchasesTypecell")
//        {
//            pickerDataSource = ["QUOTE","ORDER","BILL","DEBIT NOTE"]
//        }
        // Do any additional setup after loading the view.
    }
    @IBAction func CancelButtonClick(sender: AnyObject) {
       
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
 
    @IBAction func DoneuttonClick(sender: AnyObject) {
    var selectedValue = pickerDataSource[pickerView.selectedRowInComponent(0)]
        
        self.delegate?.sendGoBackFromView("fromPickerViewViewController" ,forCell :fromCell,selectedValue: selectedValue)
        
        navigationController?.popToRootViewControllerAnimated(true)
        print("PickView selected row" + selectedValue)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
