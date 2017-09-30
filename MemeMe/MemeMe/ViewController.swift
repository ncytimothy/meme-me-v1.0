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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    
    
    


}

