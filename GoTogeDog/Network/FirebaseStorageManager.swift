//
//  FirebaseStorageManager.swift
//  GoTogeDog
//
//  Created by 이숭인 on 2021/03/29.
//

import UIKit
import Firebase

class FirebaseStorageManager {
    static let shared = FirebaseStorageManager()
    
    let storage = Storage.storage().reference()
    
    //id -> kakao id
    func uploadOwnerImages(id : String, image : UIImage,completion : @escaping (URL)->(Void)){
        let data = image.jpegData(compressionQuality: 0.8)
        let ownerImagesRef = storage.child("ownerImages/\(id)").child("\(image.description)")
        let uploadTask = ownerImagesRef.putData(data!, metadata: nil) { (metadata, error) in
            ownerImagesRef.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    print("error -->  \(String(describing: error?.localizedDescription))")
                    return
                }
                completion(downloadUrl)
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            print("upload success")
            
            
        }
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("percent --> \(percentComplete)")
        }
    }
    
    func uploadDogImages(id : String,image : UIImage,completion : @escaping (URL)->(Void)){
        let data = image.jpegData(compressionQuality: 0.8)
        let dogImagesRef = storage.child("dogImages/\(id)").child("\(image.description)")
        let uploadTask = dogImagesRef.putData(data!, metadata: nil) { (metadata, error) in
            dogImagesRef.downloadURL { (url, error) in
                guard let downloadUrl = url else {
                    print("error -->  \(String(describing: error?.localizedDescription))")
                    return
                }
                completion(downloadUrl)
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            print("upload success")
        }
        
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("percent --> \(percentComplete)")
        }
    }
    
}
