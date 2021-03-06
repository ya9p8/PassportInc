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
    var imageStore: ImageStore!
    var profileImageUrl: URL!
    var databaseRef: FIRDatabaseReference!
    
    // MARK: IBOutlet Properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var ageTextField: UITextField!
    @IBOutlet var genderTextField: UITextField!
    @IBOutlet var profilePictureImageView: UIImageView!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageStore = ImageStore()
        databaseRef = FIRDatabase.database().reference()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(AddProfileViewController.doneButtonTapped(sender:)))
    }
    
    // MARK: IBAction Methods
    @IBAction func cameraButtonTapped(sender: UIBarButtonItem) {
       let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
     func doneButtonTapped(sender: UIBarButtonItem) {
        if self.navigationItem.leftBarButtonItem!.title == "Cancel" {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        let name = nameTextField.text!
        let age = ageTextField.text!
        let gender = genderTextField.text!
        
        if !name.isEmpty && !age.isEmpty && !gender.isEmpty && profilePictureImageView != nil {
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
                showErrorAlert(message: "Please select male or female.")
            }
            
            if let imageURL = profileImageUrl {
                let urlString = "\(imageURL)"
                
                let profileDictionary = ["name": name, "age": age, "gender": realGender, "imageURL": urlString, "color": backgroundColor.rawValue] as [String: Any]
                databaseRef.child("profiles").childByAutoId().setValue(profileDictionary)
                let _ = navigationController?.popViewController(animated: true)
            } else {
                showErrorAlert(message: "There was a problem saving the profile picture. Please try again.")
            }
            
        } else {
            showErrorAlert(message: "Please fill out all information.")
        }
    }
    
    func showErrorAlert(message: String) {
        let errorAlert = UIAlertController(title: "An error occurred.", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
        
    }
    
}


extension AddProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
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
               self.showErrorAlert(message: "There was an error saving the image. Please try again.")
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !textField.text!.isEmpty {
            self.navigationItem.leftBarButtonItem!.title = "Done"
        }
        
        return true
    }
}
