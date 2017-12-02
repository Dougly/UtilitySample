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
    
    func getVerificationCodeFor(phoneNumber: String, completion: @escaping (_ verID: String?, _ error: Error?) -> ()) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(nil, error)
            } else if let verificationID = verificationID {
                completion(verificationID, nil)
            }
        }
    }
    
    func getCredentialWith(verificationID: String, verificationCode: String) -> PhoneAuthCredential {
        return PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
    }
    
    func getCurrentUser() -> User? {
        return firebaseAuth.currentUser
    }
    
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
