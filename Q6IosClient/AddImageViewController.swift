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
    var attachedImage:UIImage?
     weak var delegate : Q6GoBackFromView?
    var fromCell = String()
    override func viewDidLoad() {
        super.viewDidLoad()
setControlAppear()
        
        if attachedImage != nil {
            imageView.image = attachedImage
            lblInfo.isHidden = true
            
        }
        // Do any additional setup after loading the view.
    }
    
    func setControlAppear()
    {
        if imageView.image == nil {
            lblInfo.isHidden = false
        }
        UseExistingPhoto.layer.cornerRadius = 2;
        UseExistingPhoto.layer.borderWidth = 0.1;
        UseExistingPhoto.layer.borderColor = UIColor.black.cgColor
        
        UseCameraButton.layer.cornerRadius = 2;
        UseCameraButton.layer.borderWidth = 0.1;
        UseCameraButton.layer.borderColor = UIColor.black.cgColor
    }
    @IBAction func UseExistingPhotoButtonClicked(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        
       
            newMedia = false
        }
    }
    @IBAction func UseCameraButtonClicked(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true, completion: nil )
            newMedia = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType.rawValue] as! NSString
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            
            let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as! UIImage
            
            imageView.image = image
            
            attachedImage = image
            
            // let pngImageData = UIImagePNGRepresentation(image,1)
            _ = image.jpegData(compressionQuality: 1)
            //   _ = pngImageData!.base64EncodedString(options: NSData.Base64EncodingOptions.Encoding64CharacterLineLength)
            lblInfo.isHidden = true
            if newMedia == true {
                //                UIImageWriteToSavedPhotosAlbum(image,self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
                
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(AddImageViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc func image(_ image:UIImage,didFinishSavingWithError error:NSErrorPointer,contextInfo:UnsafeRawPointer){
        
        if error != nil {
            Q6CommonLib.q6UIAlertPopupController(title: "Save Failed", message: "Failed to save image", viewController: self)
        }
    }

    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        if attachedImage != nil  {
            
          //  if checkImageFileSize(){
            self.delegate?.sendGoBackFromAddImageView(fromView: "AddImageViewController", forCell: "AddanImageCell", image: attachedImage!)
        
        _ = navigationController?.popViewController(animated: true)
           // }
        }
        else {
            Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "You haven't pick a photo", viewController: self) 
        }
    }
    
    func checkImageFileSize() -> Bool
    {
        
        
        let imgData: NSData = NSData(data: (attachedImage)!.jpegData(compressionQuality: 1)!)
        
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        let FileSize: Int = imgData.length
        
        
        
        print("File Size" + FileSize.description)
        if FileSize > 2000000 {
            
                  Q6CommonLib.q6UIAlertPopupController(title: "Information message", message: "Your Photo size can not over 2 MB !", viewController: self)
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
