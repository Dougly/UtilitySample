//
//  FirebaseAuthFacade.swift
//  TableMe
//
//  Created by Douglas Galante on 12/1/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import FirebaseAuth

class FirebaseAuthFacade {
    //TODO: Bring Auth logic here
    
    let firebaseAuth = Auth.auth()
    
    func logout(success: (Bool, String?) -> Void) {
        do {
            try firebaseAuth.signOut()
            success(true, nil)
        } catch let signOutError as NSError {
            let error = ("🔥 Error signing out: %@", signOutError)
            success(false, error.0)
        }
    }


}
