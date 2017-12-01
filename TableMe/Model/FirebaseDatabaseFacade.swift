//
//  FirebaseDatabaseFacade.swift
//  TableMe
//
//  Created by Douglas Galante on 11/29/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

enum ProfileValue: String {
    case name, email, gender, birthday, profileImage
}

class FirebaseDatabaseFacade {
    
    let ref = Database.database().reference()
    let users = "users"
    
    func saveUserInfo(_ name: String?, email: String?, gender: String?, birthday: String?, profileImageURL: URL?) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let phoneNumber = currentUser.phoneNumber else { return }
        let keys: [ProfileValue] = [.name, .email, .gender, .birthday, .profileImage]
        var updateInfo: [String : Any] = [:]
        for key in keys {
            switch key {
            case .name: if name != nil { updateInfo[ProfileValue.name.rawValue] = name }
            case .email: if email != nil { updateInfo[ProfileValue.email.rawValue] = email }
            case .gender: if gender != nil { updateInfo[ProfileValue.gender.rawValue] = gender }
            case .birthday: if birthday != nil { updateInfo[ProfileValue.birthday.rawValue] = birthday }
            case .profileImage: if profileImageURL != nil { updateInfo[ProfileValue.profileImage.rawValue] = email }
            }
        }
        ref.child(users).setValue([phoneNumber : updateInfo])
    }
    
    
    func updateUserInfo(_ name: String?, email: String?, gender: String?, birthday: String?, profileImageURL: URL?) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let phoneNumber = currentUser.phoneNumber else { return }
        let keys: [ProfileValue] = [.name, .email, .gender, .birthday, .profileImage]
        var updateInfo: [String : Any] = [:]
        for key in keys {
            switch key {
            case .name: if name != nil { updateInfo[ProfileValue.name.rawValue] = name }
            case .email: if email != nil { updateInfo[ProfileValue.email.rawValue] = email }
            case .gender: if gender != nil { updateInfo[ProfileValue.gender.rawValue] = gender }
            case .birthday: if birthday != nil { updateInfo[ProfileValue.birthday.rawValue] = birthday }
            case .profileImage: if profileImageURL != nil { updateInfo[ProfileValue.profileImage.rawValue] = email }
            }
        }
        
        for update in updateInfo {
            let path = "\(users)/\(phoneNumber)/\(update.key)"
            let value = update.value as! String
            ref.child(path).setValue(value)
        }
    }
    
    
    func deleteInfo(at path: String) {
        ref.child(path).removeValue()
    }
   
    
    func readValueOnce(at path: String, completion: @escaping ([String : Any]?) -> Void) {
        ref.child(path).observeSingleEvent(of: .value, with: { (snapshot) in
            let dict = snapshot.value as? [String : Any]
            completion(dict)
        }) { (error) in
            print("🔥 \(error.localizedDescription)")
        }
    }
    
    
}
