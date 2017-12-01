//
//  VerificationCodeViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/20/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import FirebaseAuth

class VerificationCodeViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var weSentVerificationLabel: UILabel!
    @IBOutlet weak var fiveDigitCodeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
        let verificationCode = textField.text!
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        loginWith(credential: credential)
        let main = UIStoryboard(name: "Main", bundle: nil)
        let additionalDetailsVC = main.instantiateViewController(withIdentifier: "additionalDetailsVC") as! AdditionalDetailsViewController
        
        //TODO: If user has already created an account go directly into app without presenting additional details or asking for permissions
        self.navigationController?.pushViewController(additionalDetailsVC, animated: true)
        
    
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func resendCodeButtonTapped(_ sender: UIButton) {
    }
    
    
    func loginWith(credential: PhoneAuthCredential) {
        activityIndicator.startAnimating()
        Auth.auth().signIn(with: credential) { (user, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print(error)
                return
            }
        }
    }
    
}
