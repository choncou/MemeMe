//
//  ViewController.swift
//  Meme Me
//
//  Created by Unathi Chonco on 2016/03/21.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBAction func pickImageFromLibrary(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: memeImage.image, memedImage: generateMemedImage())
        
        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
        presentViewController(activityController, animated: true){
//            dismissViewControllerAnimated(true, completion: nil)
            print("done")
        }
        
    }
    
    func generateMemedImage() -> UIImage{
        UIGraphicsBeginImageContext(self.view.frame.size)
        memeView.drawViewHierarchyInRect(memeView.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    //MARK: Lifecycle
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewDidAppear(animated: Bool) {
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }
    
    override func viewDidLoad() {
        shareButton.enabled = false
        topTextField.delegate = self
        bottomTextField.delegate = self
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
    }
    
    //MARK: Notifcations
    func keyboardWillShow(notification: NSNotification){
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notifcation: NSNotification) -> CGFloat{
        let userinfo = notifcation.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            shareButton.enabled = false
            return
        }
        memeImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
}

extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text?.removeAll()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

