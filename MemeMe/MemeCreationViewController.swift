//
//  ViewController.swift
//  MemeMe
//
//  Created by Joshua Smith on 5/22/15.
//  Copyright (c) 2015 Square One Nation, LLC. All rights reserved.
//

import UIKit

class MemeCreationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate
{
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var incomingMeme : Meme!
    
    let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName: -3.0]
    
    //MARK: View Lifecycle Methods
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        //Subscribe to keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Set up UITextFields
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        self.topTextField.defaultTextAttributes = memeTextAttributes as [NSObject : AnyObject]
        self.bottomTextField.defaultTextAttributes = memeTextAttributes as [NSObject : AnyObject]
        self.topTextField.textAlignment = .Center
        self.bottomTextField.textAlignment = .Center
        //populate with existing meme, if present
        if let meme = incomingMeme
        {
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            image.image = meme.image
        }
        else
        {
            //Placeholder text
            self.topTextField.text = "TOP"
            self.bottomTextField.text = "BOTTOM"
            //default save and share buttons to disabled
            self.saveButton.enabled = false
            self.shareButton.enabled = false
        }
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        //Unsubscribe from keyboard notifications
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IBActions

    @IBAction func pickButtonPressed(sender: AnyObject)
    {
        //Check for camera
        if UIImagePickerController.isSourceTypeAvailable(.Camera)
        {
            //Prompt user for source
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Choose an existing photo", "Take a photo")
            actionSheet.showInView(self.view)
        }
        else
        {
            //Show Image Picker
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .PhotoLibrary
            self.presentViewController(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject)
    {
        let meme = Meme(image: image.image!, topText: topTextField.text, bottomText: bottomTextField.text)
        
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //check whether to save to existing array index or add new entry
        if incomingMeme != nil && incomingMeme.index != nil
        {
            appDelegate.memes[incomingMeme.index] = meme
        }
        else
        {
            appDelegate.memes.append(meme)
        }
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject)
    {
        let meme = Meme(image: image.image!, topText: topTextField.text, bottomText: bottomTextField.text)
        let activitySheet = UIActivityViewController(activityItems: [meme.generateMemedImage()], applicationActivities: nil)
        self.presentViewController(activitySheet, animated: true, completion: nil)
    }
    
    //MARK: Delegate Methods
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        switch buttonIndex
        {
        case 1: //Existing Image
            pickerController.sourceType = .PhotoLibrary
            self.presentViewController(pickerController, animated: true, completion: nil)
        case 2: //Camera
            pickerController.sourceType = .Camera
            self.presentViewController(pickerController, animated: true, completion: nil)
        default: //Cancel
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        self.image.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //Enable save & share buttons
        if self.image.image != nil
        {
            self.saveButton.enabled = true
            self.shareButton.enabled = true
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        //Check for default text
        if textField == topTextField && topTextField.text == "TOP"
        {
            topTextField.text = ""
        }
        else if textField == bottomTextField && bottomTextField.text == "BOTTOM"
        {
            self.bottomTextField.text = ""
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        //Check for empty text fields
        if textField.text == ""
        {
            if textField == topTextField
            {
                topTextField.text = "TOP"
            }
            else if textField == bottomTextField
            {
                bottomTextField.text = "BOTTOM"
            }
        }
        return true
    }
    
    //MARK: Local Methods
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if self.bottomTextField.isFirstResponder()
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if self.bottomTextField.isFirstResponder()
        {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
}

