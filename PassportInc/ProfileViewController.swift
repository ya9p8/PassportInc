//
//  ProfileViewController.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProfileViewController: UIViewController {
    // MARK: Custom Properties
    var profileToView: Profile!
    var ref: FIRDatabaseReference!
    
    // MARK: IBOutlet Properties
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var hobbiesTextView: UITextView!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        
        self.navigationItem.title = profileToView.name
        self.genderLabel.text = profileToView.gender
        self.ageLabel.text = "\(profileToView.age)"
        self.profileImageView.image = profileToView.image
        
        setBackgroundColor()
    
        
        ref = FIRDatabase.database().reference().child("profiles").child(profileToView.id)
    }
    
    func setBackgroundColor() {
        var background: UIColor!
        
        
        switch profileToView.backgroundColor! {
        case .blue:
            background = UIColor.blue
        case .red:
            background = UIColor.red
        case .green:
            background = UIColor.green
        case .orange:
            background = UIColor.orange
        case .yellow:
            background = UIColor.yellow
        case .white:
            background = UIColor.white
        }
        
        self.view.backgroundColor = background
    }
    
    @IBAction func addAHobbyButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func onChangeColorButtonTapped(_ sender: UIBarButtonItem) {
        let changeColorPrompt = UIAlertController(title: "Change Background Color", message: nil, preferredStyle: .actionSheet)
        
        for color in ProfileColor.allValues {
            let action = UIAlertAction(title: color.rawValue.capitalized, style: .default, handler: { (_) in
                self.profileToView.backgroundColor = color
                self.setBackgroundColor()
                
                self.ref.child("color").setValue(self.profileToView.backgroundColor!.rawValue)
            })
            
            changeColorPrompt.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        
        changeColorPrompt.addAction(cancelAction)
        
        present(changeColorPrompt, animated: true, completion: nil)
    }
    
}
