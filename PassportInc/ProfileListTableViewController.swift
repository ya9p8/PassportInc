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
    var filteredProfiles:[Profile] = []
    
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
    
    // MARK: IBAction Methods
    @IBAction func sortAndFilterButtonTapped(_ sender: UIBarButtonItem) {
        // Present options
        let optionsAlert = UIAlertController(title: "Sort/Filter By:", message: nil, preferredStyle: .actionSheet)
        
        let filterOnlyMalesAction = UIAlertAction(title: "Filter By Male", style: .default) { (_) in
            self.filteredProfiles = self.profiles.filter { $0.gender == "M" }
            print(self.filteredProfiles)
            self.tableView.reloadData()
        }
        
        let filterOnlyFemalesAction = UIAlertAction(title: "Filter By Female", style: .default) { (_) in
            self.filteredProfiles = self.profiles.filter { $0.gender == "F" }
            self.tableView.reloadData()
        }
        
        let sortByNameAction = UIAlertAction(title: "Sort By Name", style: .default) { (_) in
            self.filteredProfiles = self.profiles.sorted{$0.0.name < $0.1.name }
            self.tableView.reloadData()
        }
        
        let sortByAge = UIAlertAction(title: "Sort By Age", style: .default) { (_) in
            self.filteredProfiles = self.profiles.sorted{$0.0.age < $0.1.age }
            self.tableView.reloadData()
        }
        
        let clearFilterSortAction = UIAlertAction(title: "Clear Sorts and Filters", style: .default) { (_) in
            self.filteredProfiles.removeAll()
            self.tableView.reloadData()
        }

        
        optionsAlert.addAction(filterOnlyMalesAction)
        optionsAlert.addAction(filterOnlyFemalesAction)
        optionsAlert.addAction(sortByNameAction)
        optionsAlert.addAction(sortByAge)
        optionsAlert.addAction(clearFilterSortAction)
        present(optionsAlert, animated: true, completion: nil)
    }
    
    // MARK: UITableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProfiles.isEmpty ? profiles.count : filteredProfiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileTableViewCell
        let profile = filteredProfiles.isEmpty ? profiles[indexPath.row] : filteredProfiles[indexPath.row]
        cell.profile = profile

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove from database
            let profileToDelete = profiles[indexPath.row]
            ref.child(profileToDelete.id).removeValue()
            
            // delete picture from storage
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(withPath: "gs://passportinc-8091c.appspot.com")
            let imageRef = storageRef.child("images").child(profileToDelete.imageURLString!)
            imageRef.delete(completion: { (error) in
                if error != nil { print(error?.localizedDescription) }
                else { self.tableView.reloadData() }
            })
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
