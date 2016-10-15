//
//  ImageStore.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/14/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//

import UIKit
import FirebaseStorage

class ImageStore {
    
    private var imageStorage: FIRStorage!
    private var imageStorageRef: FIRStorageReference!
    private var imageRef: FIRStorageReference!
    
    init() {
        imageStorage = FIRStorage.storage()
        imageStorageRef = imageStorage.reference(withPath: "gs://passportinc-8091c.appspot.com")
        imageRef = imageStorageRef.child("images")
    }
   
    //func uploadImage(image: UIImage)
}
