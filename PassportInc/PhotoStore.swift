//
//  PhotoStore.swift
//  PassportInc
//
//  Created by Yemi Ajibola on 10/16/16.
//  Copyright © 2016 Yemi Ajibola. All rights reserved.
//


// THIS CLASS IS RESPONSIBLE FOR WEB SERVICE REQUESTS TO DOWNLOAD IMAGES FROM DATABASE

import UIKit
import FirebaseStorage

enum ImageResult {
    case Success(UIImage)
    case Failure(Error)
}

enum PhotoError: Error {
    case ImageCreationError
}

class PhotoStore {
    let photoStorage = FIRStorage.storage()
    let photoStorageRef = FIRStorage.storage().reference(withPath: "gs://passportinc-8091c.appspot.com")
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchImageFor(_ profile: inout Profile, completion: @escaping (ImageResult) -> Void) {
        
        if let image = profile.image {
            completion(.Success(image))
            return
        }
        
        
        
        let imageURL = URL(string: profile.imageURLString!)
        let request = URLRequest(url: imageURL!)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                //Set image
                profile.image = image
            }
            completion(result)
        }
        
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            if data == nil {
                return .Failure(error!)
            }
            else {
                return .Failure(PhotoError.ImageCreationError)
            }
        }
        
        return .Success(image)
    }
}
