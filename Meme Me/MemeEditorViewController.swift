//
//  ViewController.swift
//  Meme Me
//
//  Created by Unathi Chonco on 2016/03/21.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
//MARK: IBAction
    
    @IBAction func pickImageFromLibrary(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        pickImageFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: memeImage.image, memedImage: generateMemedImage())
        
        
        let activityController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { handler in
            // handler is made up of: (String?, Bool, [AnyObject]?, NSError?)
            if handler.1{
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
                self.closeEditor()
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelEditing(sender: UIBarButtonItem){
        closeEditor()
    }
    
    func closeEditor(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func pickImageFromSource(source: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage{
        UIGraphicsBeginImageContext(self.view.frame.size)
        memeView.drawViewHierarchyInRect(memeView.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func addMemeTextAttrib(textView: UITextField){
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSStrokeWidthAttributeName : -3.0
        ]
        
        textView.defaultTextAttributes = memeTextAttributes
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
        addMemeTextAttrib(topTextField)
        addMemeTextAttrib(bottomTextField)
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
//MARK: Notifcations
    func keyboardWillShow(notification: NSNotification){
        if bottomTextField.isFirstResponder(){
            self.view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
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

//MARK: Extensions
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            shareButton.enabled = false
            return
        }
        memeImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
        
        //TODO: Adjust so textfields do not overlap only part of portrait image
    }
    
}

extension MemeEditorViewController: UITextFieldDelegate{
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

