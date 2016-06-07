//
//  AddImageViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 25/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit
import MobileCoreServices
class AddImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

   
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var UseExistingPhoto: UIButton!
    @IBOutlet weak var UseCameraButton: UIButton!
    var newMedia: Bool?
    var attachedImage = UIImage?()
     weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        
        if attachedImage != nil {
            imageView.image = attachedImage
        }
        // Do any additional setup after loading the view.
    }
    
    func setControlAppear()
    {
        if imageView.image == nil {
            lblInfo.hidden = false
        }
        UseExistingPhoto.layer.cornerRadius = 2;
        UseExistingPhoto.layer.borderWidth = 0.1;
        UseExistingPhoto.layer.borderColor = UIColor.blackColor().CGColor
        
        UseCameraButton.layer.cornerRadius = 2;
        UseCameraButton.layer.borderWidth = 0.1;
        UseCameraButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    @IBAction func UseExistingPhotoButtonClicked(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newMedia = false
        }
    }
    @IBAction func UseCameraButtonClicked(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker,animated: true, completion: nil )
            newMedia = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as String) {
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            imageView.image = image
            
            attachedImage = image
           // let pngImageData = UIImagePNGRepresentation(image,1)
          let pngImageData = UIImageJPEGRepresentation(image, 1)
     var base64String = pngImageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            lblInfo.hidden = true
            if newMedia == true {
                UIImageWriteToSavedPhotosAlbum(image,self, "image:didFinishSavingWithError:contextInfo:", nil)
            }
        }
    }
    
    func image(image:UIImage,didFinishSavingWithError error:NSErrorPointer,contextInfo:UnsafePointer<Void>){
        
        if error != nil {
            Q6CommonLib.q6UIAlertPopupController("Save Failed", message: "Failed to save image", viewController: self)
        }
    }

    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        if attachedImage != nil  {
            
          //  if checkImageFileSize(){
            self.delegate?.sendGoBackFromAddImageView("AddImageViewController", forCell: "AddanImageCell", image: attachedImage!)
        
        navigationController?.popViewControllerAnimated(true)
           // }
        }
        else {
            Q6CommonLib.q6UIAlertPopupController("Information message", message: "You haven't pick a photo", viewController: self) 
        }
    }
    
    func checkImageFileSize() -> Bool
    {
        
        
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((attachedImage)!, 1)!)
        
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        var FileSize: Int = imgData.length
        
        
        
        print("File Size" + FileSize.description)
        if FileSize > 2000000 {
            
                  Q6CommonLib.q6UIAlertPopupController("Information message", message: "Your Photo size can not over 2 MB !", viewController: self)
            return false
        }
        else {
            return true
        }
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
