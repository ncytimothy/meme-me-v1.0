//
//  ViewController.swift
//  MemeMe
//
//  Created by Timothy Ng on 9/30/17.
//  Copyright © 2017 Timothy Ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    var memedImage: UIImage?

    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatText()
        enableShare()
        enableReset()
    }
    

    func formatText() {
        topTextfield.text = topDefaultText
        bottomTextfield.text = bottomDefaultText
        topTextfield.delegate = self
        bottomTextfield.delegate = self
        
        topTextfield.resignFirstResponder()
        bottomTextfield.resignFirstResponder()
        
        let memeTextFormat: [String:Any] = [NSAttributedStringKey.strokeColor.rawValue:UIColor.black, NSAttributedStringKey.foregroundColor.rawValue:UIColor.white, NSAttributedStringKey.font.rawValue:UIFont.init(name: "HelveticaNeue-CondensedBlack", size: 40), NSAttributedStringKey.strokeWidth.rawValue:-3.0]
        topTextfield.defaultTextAttributes = memeTextFormat
        bottomTextfield.defaultTextAttributes = memeTextFormat
        topTextfield.textAlignment = .center
        bottomTextfield.textAlignment = .center
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enableReset()
        enableShare()
        return true
    }
    
    func enableShare() {
        shareButton.isEnabled = imagePickerView.image != nil
    }
    
    func enableReset() {
        cancelButton.isEnabled = topTextfield.text != topDefaultText || bottomTextfield.text != bottomDefaultText || imagePickerView.image != nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    @IBAction func pressCancel (_ sender: Any) {
        formatText()
        imagePickerView.image = nil
        cancelButton.isEnabled = false
        shareButton.isEnabled = false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            print("Tag: \(textField.tag)")
            switch textField.tag {
            case 0:
                textField.text = topDefaultText
            case 1:
                textField.text = bottomDefaultText
            default:
                return true
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.imagePickerView.image = image
            self.imagePickerView.contentMode = .scaleAspectFit
            enableReset()
            enableShare()
        }
         self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("keyboardWillShow called")
        if bottomTextfield.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: NSNotification)  -> CGFloat {
        print("getkeyBoardHeight called")
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        print("subscribeToKeyboardNotifications called")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        print("unsubscribeToKeyboardNotifications called")
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func generateMemedImge() -> UIImage {
        // TODO: Hide toolbar and navbar

        toolbar.isHidden = true
        navigationBar.isHidden = true
        

        // Render view to an image
    
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        toolbar.isHidden = false
        navigationBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func share(_ sender: Any) {
        print("share called")
        let memedImage = generateMemedImge()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    
    func save() {
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, originalImage: imagePickerView.image!, memedImage: memedImage!)
    }
    
   
    
}

