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
    case name, email, gender, birthday, profileImage, venmoID, description
}

class FirebaseDatabaseFacade {
    
    let auth = FirebaseAuthFacade()
    let ref = Database.database().reference()
    let users = "users"
    let dataStore = DataStore.sharedInstance
    
    func saveUserInfo(_ name: String?, email: String?, gender: String?, birthday: String?, profileImageURL: URL?) {
        guard let currentUser = auth.getCurrentUser() else { return }
        guard let phoneNumber = currentUser.phoneNumber else { return }
        let keys: [ProfileValue] = [.name, .email, .gender, .birthday, .profileImage]
        var userInfo: [String : Any] = [:]
        for key in keys {
            switch key {
            case .name:
                if name != nil { userInfo[ProfileValue.name.rawValue] = name }
            case .email:
                if email != nil { userInfo[ProfileValue.email.rawValue] = email }
            case .gender:
                if gender != nil { userInfo[ProfileValue.gender.rawValue] = gender }
            case .birthday:
                if birthday != nil { userInfo[ProfileValue.birthday.rawValue] = birthday }
            case .profileImage:
                if profileImageURL != nil { userInfo[ProfileValue.profileImage.rawValue] = profileImageURL?.absoluteString }
            case .venmoID, .description:
                break
            }
        }
        let path = "\(users)/\(phoneNumber)"
        ref.child(path).setValue(userInfo)
    }
    
    
    func updateUserInfo(_ name: String?, email: String?, gender: String?, birthday: String?, profileImageURL: URL?, venmoID: String?, description: String?) {
        guard let currentUser = auth.getCurrentUser() else { return }
        guard let phoneNumber = currentUser.phoneNumber else { return }
        let keys: [ProfileValue] = [.name, .email, .gender, .birthday, .profileImage, .venmoID, .description]
        var updateInfo: [String : Any] = [:]
        for key in keys {
            switch key {
            case .name: if name != nil { updateInfo[ProfileValue.name.rawValue] = name! }
            case .email: if email != nil { updateInfo[ProfileValue.email.rawValue] = email! }
            case .gender: if gender != nil { updateInfo[ProfileValue.gender.rawValue] = gender! }
            case .birthday: if birthday != nil { updateInfo[ProfileValue.birthday.rawValue] = birthday! }
            case .profileImage: if profileImageURL != nil { updateInfo[ProfileValue.profileImage.rawValue] = profileImageURL?.absoluteString }
            case .venmoID: if venmoID != nil { updateInfo[ProfileValue.venmoID.rawValue] = venmoID! }
            case .description: if description != nil { updateInfo[ProfileValue.description.rawValue] = description! }
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
    
    func setListnerForUser(_ path: String) {
        ref.child(path).observe(.value) { snapshot in
            let dict = snapshot.value as? [String : Any] ?? [:]
            self.dataStore.userInfo = dict
            self.dataStore.name = dict["name"] as? String ?? ""
            self.dataStore.email = dict["email"] as? String ?? ""
            self.dataStore.gender = dict["gender"] as? String ?? ""
            self.dataStore.birthday = dict["birthday"] as? String ?? ""
            self.dataStore.profileImage = dict["profileImage"] as? String ?? ""
            self.dataStore.description = dict["description"] as? String ?? ""
            self.dataStore.venmoID = dict["venmoID"] as? String ?? ""
            print(self.dataStore.userInfo)
        }
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
