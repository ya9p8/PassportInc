//
//  ProfileListTableViewController.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class ProfileListTableViewController: UITableViewController {
    var profiles:[Profile] = []
    var ref: FIRDatabaseReference!
    
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(withPath: "profiles")
        
        fetchProfiles()
    }
    
    // MARK: Custom Methods
    func fetchProfiles() {
        ref.observe(.value, with: { snapshot in
            var newProfiles: [Profile] = []
            
            for profile in snapshot.children {
                let newProfile = Profile(snapshot: profile as! FIRDataSnapshot)
                newProfiles.append(newProfile)
            }
            
            self.profiles = newProfiles
            self.tableView.reloadData()
        })
        
        
    }
    
    // MARK: UITableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileTableViewCell
        cell.profile = profiles[indexPath.row]
        
        return cell
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileView" {
            let destination = segue.destination as! ProfileViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destination.profileToView = profiles[selectedIndexPath!.row]
        }
    }
    
}
