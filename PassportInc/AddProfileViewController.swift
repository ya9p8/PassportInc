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
    var profileImageUrl: URL!
    let databaseRef = FIRDatabase.database().reference()
    
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
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        if let name = nameTextField.text, let age = ageTextField.text, let gender = genderTextField.text {
            let lowercasedGender = gender.lowercased()
            var realGender: String!
            var backgroundColor: ProfileColor!
            if lowercasedGender == "m" || lowercasedGender == "male" {
                realGender = "M"
                backgroundColor = .blue
            } else if lowercasedGender == "f" || lowercasedGender == "female" {
                realGender = "F"
                backgroundColor = .green
            } else {
                // ERROR
            }
            
            if let imageURL = profileImageUrl {
                let urlString = "\(imageURL)"
                
                let profileDictionary = ["name": name, "age": age, "gender": realGender, "imageURL": urlString, "color": backgroundColor.rawValue] as [String: Any]
                databaseRef.child("profiles").childByAutoId().setValue(profileDictionary)
                let _ = navigationController?.popViewController(animated: true)
            } else {
                print("Error with profile URL")
            }
            
        } else {
            print("Please fill out all information")
        }
        
       
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
                self.profileImageUrl = url
                self.dismiss(animated: true, completion: nil)
            } else {
                print("There was an error")
            }
        }
        
       
    }
    
}
