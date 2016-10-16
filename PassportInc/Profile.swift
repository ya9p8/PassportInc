//
//  Profile.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

enum ProfileColor : String {
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case blue = "blue"
    case white = "white"
    
    static let allValues = [red, orange, yellow, green, blue, white]
}

struct Profile {
    var name: String
    var age: String
    var id: String
    var image: UIImage?
    var imageURLString: String?
    var hobbies: [String]?
    var gender: String
    var backgroundColor: ProfileColor?
    
    init(name: String, age: String, gender: String, id: String = "") {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
    }
    
    init(snapshot: FIRDataSnapshot) {
        id = snapshot.key
       let profileDictionary = snapshot.value as! [String: AnyObject]
        
        name = profileDictionary["name"] as! String
        age = profileDictionary["age"] as! String
        gender = profileDictionary["gender"] as! String
        imageURLString = profileDictionary["imageURL"] as! String?
        if let color = profileDictionary["color"] as! String? {
            backgroundColor = ProfileColor(rawValue: color)
        }
        
        let imageStore = ImageStore()
        image = imageStore.downloadImage(imageURLString: imageURLString)
    }
    
}
