//
//  ViewController.swift
//  MemeMe
//
//  Created by Timothy Ng on 9/30/17.
//  Copyright © 2017 Timothy Ng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottownTextfield: UITextField!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextfield.text = "TOP"
        
        bottownTextfield.text = "BOTTOM"
        bottownTextfield.textAlignment = .center
        var memeTextFormat: [String:Any] = [NSAttributedStringKey.strokeColor.rawValue:UIColor.black, NSAttributedStringKey.foregroundColor.rawValue:UIColor.white, NSAttributedStringKey.font.rawValue:UIFont.init(name: "HelveticaNeue-CondensedBlack", size: 40), NSAttributedStringKey.strokeWidth.rawValue:-3.0]
        topTextfield.defaultTextAttributes = memeTextFormat
        bottownTextfield.defaultTextAttributes = memeTextFormat
        topTextfield.textAlignment = .center
        bottownTextfield.textAlignment = .center
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        albumButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
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
    
    
    
    


}

