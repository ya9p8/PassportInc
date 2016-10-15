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
    
    typealias Completion = (_ success: Bool, _ url: URL) -> Void
    
    init() {
        imageStorage = FIRStorage.storage()
        imageStorageRef = imageStorage.reference(withPath: "gs://passportinc-8091c.appspot.com")
        imageRef = imageStorageRef.child("images")
    }
   
    func uploadImage(image: UIImage, completionHandler: @escaping Completion) {
        let data = UIImageJPEGRepresentation(image, 1.0)
        var downloadURL: URL!
        var flag: Bool!
        let filePath = "\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        imageRef.child(filePath).put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Error: \(error?.localizedDescription)\n\n\n")
               // flag =  false
                return
            }
            flag  = true
            downloadURL = metadata?.downloadURL()
            completionHandler(flag, downloadURL)
        }
        
       
    }
    
    func downloadImage(imageURLString:String?) -> UIImage? {
        
        let imageURL = URL(string: imageURLString!)
        
        do {
            let data = try Data(contentsOf: imageURL!)
            // Convert to image
            return UIImage(data: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
