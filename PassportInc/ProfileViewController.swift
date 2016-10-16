//
//  ProfileViewController.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Custom Properties
    var profileToView: Profile!
    var ref: FIRDatabaseReference!
    
    // MARK: IBOutlet Properties
    @IBOutlet var genderLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var hobbiesTableView: UITableView!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        
        self.navigationItem.title = profileToView.name
        self.genderLabel.text = profileToView.gender
        self.ageLabel.text = "\(profileToView.age)"
        self.profileImageView.image = profileToView.image
        
        setBackgroundColor()
    
        
        ref = FIRDatabase.database().reference().child("profiles").child(profileToView.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchHobbies()
    }
    
    //MARK: Custom Functions
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
    
    func fetchHobbies() {
        ref.child("hobbies").observe(.value, with: { snapshot in
            var fetchedHobbies: [Hobby] = []
            
            for snap in snapshot.children {
                let hobby = Hobby(snapshot: snap as! FIRDataSnapshot)
                fetchedHobbies.append(hobby)
            }
            
            self.profileToView.hobbies = fetchedHobbies
            self.hobbiesTableView.reloadData()
        })
    }
    
    
    // MARK: UITableView Delegate Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HobbyCell")!
        let hobby = profileToView.hobbies![indexPath.row] 
        cell.textLabel?.text = hobby.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let hobbyArray = self.profileToView.hobbies else { return 0 }
        
        return hobbyArray.count
    }
    
    // MARK: IBAction Methods
    @IBAction func addAHobbyButtonTapped(_ sender: UIBarButtonItem) {
        let hobbyAlert = UIAlertController(title: "Add a Hobby", message: nil, preferredStyle: .alert)
        hobbyAlert.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let hobbyText = hobbyAlert.textFields!.first!.text
            
            // Add hobby to database
            self.ref.child("hobbies").childByAutoId().setValue(hobbyText)
        
            self.fetchHobbies()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        hobbyAlert.addAction(okAction)
        hobbyAlert.addAction(cancelAction)
        present(hobbyAlert, animated: true, completion: nil)
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
