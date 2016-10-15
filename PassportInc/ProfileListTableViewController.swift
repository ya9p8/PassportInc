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
    var imageStore: ImageStore!
    
    // MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference(withPath: "profiles")
        imageStore = ImageStore()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
            
            self.profiles = newProfiles.sorted{$0.0.id < $0.1.id}
            self.tableView.reloadData()
        })
    }
    
    // MARK: UITableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileTableViewCell
        let profile = profiles[indexPath.row]
        cell.profile = profile

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove from database
            let profileToDelete = profiles[indexPath.row]
            ref.child(profileToDelete.id).removeValue()
            self.tableView.reloadData()
        }
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
