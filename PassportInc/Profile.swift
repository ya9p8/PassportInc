//
//  Profile.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit
import Firebase

struct Profile {
    var name: String
    var age: Int
    var id: String
    var backgroundColor: UIColor?
    var image: UIImage?
    var hobbies: [String]?
    var gender: String
    
    init(name: String, age: Int, gender: String, id: String = "") {
        self.id = id
        self.name = name
        self.age = age
        self.gender = gender
        
       self.backgroundColor =  (self.gender == "M" ?  UIColor.blue : UIColor.green)
    }
}
