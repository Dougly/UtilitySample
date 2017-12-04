//
//  FirebaseStorageFacade.swift
//  TableMe
//
//  Created by Douglas Galante on 12/4/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

class FirebaseStorageFacade {
    
    let storage = Storage.storage()
    let auth = FirebaseAuthFacade()
    
    func uploadProfileImage(data: Data, completion: @escaping (StorageMetadata) -> Void) {
        guard let currentUser = auth.getCurrentUser() else { return }
        guard let phoneNumber = currentUser.phoneNumber else { return }
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let profilePictureRef = imagesRef.child("\(phoneNumber)ProfilePicture.jpg")
        
        profilePictureRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print("🔥 error: \(error)")
                return
            } else if let metadata = metadata {
                completion(metadata)
            }
        }
    }
    
    
}
