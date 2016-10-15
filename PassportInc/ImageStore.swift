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
    //private var profileRef: FIRStorageReference!
    private var imageRef: FIRStorageReference!
    
    init() {
        imageStorage = FIRStorage.storage()
        imageStorageRef = imageStorage.reference(withPath: "gs://passportinc-8091c.appspot.com")
        //profileRef = imageStorageRef.child(<#T##path: String##String#>)
        imageRef = imageStorageRef.child("images")
    }
   
    func uploadImage(image: UIImage) -> URL {
        let data = UIImageJPEGRepresentation(image, 1.0)
        var downloadURL: URL!
        let profilePictureRef = imageStorageRef.child("images/profile.jpg")
        
        let uploadTask = profilePictureRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            downloadURL = metadata?.downloadURL()
            
        }
        uploadTask.resume()
        
        return downloadURL
    }
    
    func downloadImage(imageURL: URL) -> UIImage {
        
        
        return UIImage()
    }
}
