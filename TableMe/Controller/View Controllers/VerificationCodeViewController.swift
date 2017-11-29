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
        
        self.loginWith(credential: credential)
        let main = UIStoryboard(name: "Main", bundle: nil)
        let additionalDetailsVC = main.instantiateViewController(withIdentifier: "additionalDetailsVC") as! AdditionalDetailsViewController
        self.navigationController?.pushViewController(additionalDetailsVC, animated: true)
        
        let loginVC = navigationController?.viewControllers.first as! ViewController
        loginVC.loginWith(credential: credential)
        self.navigationController?.popToRootViewController(animated: true)
        
    
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func resendCodeButtonTapped(_ sender: UIButton) {
    }
    
    
    func loginWith(credential: PhoneAuthCredential) -> Bool {
        activityIndicator.startAnimating()
        Auth.auth().signIn(with: credential) { (user, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print(error)
                return
            }
            
            
            
            // User is signed in
            // ...
        }
        return true
    }
    
}
