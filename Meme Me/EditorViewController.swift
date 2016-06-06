//
//  ViewController.swift
//  Meme Me
//
//  Created by Layne Faler on 6/6/16.
//  Copyright © 2016 Layne Faler. All rights reserved.

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var editorImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var titleNavBar: UINavigationItem!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var wholeNavBar: UINavigationBar!
    @IBOutlet weak var wholeToolBar: UIToolbar!
    
    var selectedTextField: UITextField?
    var fontAttributes: FontAttributes!
    var editMeme: Meme?
    var userIsEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultUIState()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        subscribeToKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        unsubsribeToKeyboardNotification()
    }
    
    
    func setDefaultUIState() {
        let textFieldArray = [topTextfield, bottomTextfield]
        
        if let editMeme = editMeme {
            titleNavBar.title = "Edit your Meme"
            
            topTextfield.text = editMeme.topText
            bottomTextfield.text = editMeme.bottomText
            editorImage.image = editMeme.originalImage
            
            userIsEditing = true
            fontAttributes = editMeme.fontAttributes
            configureTextFields(textFieldArray)
        } else {
            titleNavBar.title = "Create a Meme"
            fontAttributes = FontAttributes()
            editorImage.backgroundColor = UIColor.blackColor()
            editorImage.image = nil
            topTextfield.text = "TOP"
            bottomTextfield.text = "BOTTOM"
            configureTextFields(textFieldArray)
        }
        
        actionButton.enabled = userIsEditing
        cancelButton.enabled = userIsEditing
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func userCanSave() -> Bool {
        if topTextfield.text == nil || bottomTextfield.text == nil || editorImage.image == nil {
            return false
        } else {
            return true
        }
    }
    
    func saveMeme() {
        
        if userCanSave() {
            
            let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: editorImage.image!, memedImage: generateMemedImage(), fontAttributes: fontAttributes)
            
            if userIsEditing {
                
                if let editMeme = editMeme {
                    CollectionOfMemes.update(atIndex: CollectionOfMemes.indexOf(editMeme), withMeme: meme)
                }
                
                // detail view controller
                
            } else {
                CollectionOfMemes.add(meme)
                dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            
            let okAction = UIAlertAction(title: "Save", style: .Default, handler: { Void in
                self.topTextfield.text = ""
                self.bottomTextfield.text = ""
                return
            })
            let editAction = UIAlertAction(title: "Edit", style: .Default, handler: nil)
            
            alertUser(message: "Your meme is missing something.", actions: [okAction, editAction])
            clearView() // error?
        }
    }
    
    func alertUser(title: String! = "Title", message: String?, actions: [UIAlertAction]) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        for action in actions {
            ac.addAction(action)
        }
        presentViewController(ac, animated: true, completion: nil)
    }


    func configureTextFields(textFields: [UITextField!]){
        for textField in textFields {
            textField.delegate = self
            
            /* Define default Text Attributes */
            let memeTextAttributes = [
                NSStrokeColorAttributeName: fontAttributes.borderColor,
                NSForegroundColorAttributeName: fontAttributes.fontColor,
                NSFontAttributeName: UIFont(name: fontAttributes.fontName, size: fontAttributes.fontSize)!,
                NSStrokeWidthAttributeName: fontAttributes.strokeSize]
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .Center
        }
    }
    
    @IBAction func actionButtonPressed(sender: AnyObject) {
        let ac = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        ac.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.saveMeme()
            }
        }
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        wholeNavBar.hidden = true
        wholeToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        wholeNavBar.hidden = false
        wholeToolBar.hidden = false
        
        return memedImage
    }
    
    func clearView() {
        editorImage.image = nil
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        if CollectionOfMemes.allMemes.count == 0 {
            clearView()
        }else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        imagePickerControllerSource(.Camera)
    }

    @IBAction func albumButtonPressed(sender: AnyObject) {
        imagePickerControllerSource(.SavedPhotosAlbum)
    }
    
}

extension EditorViewController {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        editorImage.image = nil
        let userSelectedImageVal = info[UIImagePickerControllerOriginalImage] as! UIImage
        editorImage.image = userSelectedImageVal
        actionButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerSource(controllerSource: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = controllerSource
        imagePickerController.allowsEditing = false
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension EditorViewController {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        selectedTextField = textField
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        selectedTextField = nil
        configureTextFields([textField])
        
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubsribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        
        configureTextFields([topTextfield, bottomTextfield])
    }
    
    func keyboardWillShow(notification: NSNotification) {
        selectedTextField?.text = ""
        if selectedTextField == bottomTextfield && view.frame.origin.y == 0.0 {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
}
