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
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
        topTextfield.delegate = self
        bottomTextfield.delegate = self
        
        let memeTextFormat: [String:Any] = [NSAttributedStringKey.strokeColor.rawValue:UIColor.black, NSAttributedStringKey.foregroundColor.rawValue:UIColor.white, NSAttributedStringKey.font.rawValue:UIFont.init(name: "HelveticaNeue-CondensedBlack", size: 40), NSAttributedStringKey.strokeWidth.rawValue:-3.0]
        topTextfield.defaultTextAttributes = memeTextFormat
        bottomTextfield.defaultTextAttributes = memeTextFormat
        topTextfield.textAlignment = .center
        bottomTextfield.textAlignment = .center
        
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

    @IBAction func pressCancel(_ sender: Any) {
        if topTextfield.text == "" {
            topTextfield.text = "TOP"
        }
        topTextfield.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            print("Tag: \(textField.tag)")
            switch textField.tag {
            case 0:
                textField.text = "TOP"
            case 1:
                textField.text = "BOTTOM"
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
}

