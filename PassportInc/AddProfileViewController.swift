//
//  AddProfileViewController.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddProfileViewController: UIViewController {
    
    // MARK: Custom Properties
    var imageStore = ImageStore()
    var profile: Profile!
    
    // MARK: IBOutlet Properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var profilePictureImageView: UIImageView!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBAction Methods
    @IBAction func cameraButtonTapped(sender: UIBarButtonItem) {
       let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        let profileAlert = UIAlertController(title: "Must create profile", message: "Please fill out the information before continuing.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        profileAlert.addAction(okAction)
        
        if let _ = profile {
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Alert them to fill out the information before selecting a profile pic
            present(profileAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
    }
    
}

extension AddProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        profilePictureImageView.image = image
        imageStore.uploadImage(image: image) { (success, url) in
            if success {
                self.profile.imageURL = url
            } else {
                // Error
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
