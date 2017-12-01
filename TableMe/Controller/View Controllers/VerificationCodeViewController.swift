//
//  VerificationCodeViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/20/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import FirebaseAuth

class VerificationCodeViewController: UIViewController, TableMeTextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var phoneNumber: String? // use to resend code and update label
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var weSentVerificationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableMeTextField: TableMeTextFieldView!
    @IBOutlet weak var resendTableMeButton: TableMeButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let last4 = getLastFourChars(of: phoneNumber)
        weSentVerificationLabel.text = "We sent you a 6 digit code to cell number ending in \(last4). Please enter it below."
        
        tableMeTextField.set(labelText: "6 Digit Code")
        tableMeTextField.setTextFieldProperties(nil, capitalization: .none, correction: .no, keyboardType: .numberPad, keyboardAppearance: .dark, returnKey: .done)
        tableMeTextField.textField.maxLength = 6
        tableMeTextField.delegate = self
        
        resendTableMeButton.setProperties(title: "Resend Code", icon: nil, backgroundImage: nil, backgroundColor: .black, cornerRadius: nil)
        resendTableMeButton.labelUnderline.isHidden = false
        resendTableMeButton.labelUnderline.backgroundColor = .themeGray
        resendTableMeButton.titleLabel.textColor = .themeGray
        resendTableMeButton.titleLabel.font = UIFont(name: "Avenir", size: 15)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(resendTableMeButton.titleLabel.frame.width)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
        let verificationCode = tableMeTextField.textField.text!
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        loginWith(credential: credential)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resendCodeButtonTapped(_ sender: UIButton) {
        if let phoneNumber = phoneNumber {
            //TODO: Move to FirebaseAuthFacade
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    self.activityIndicator.stopAnimating()
                    self.presentAlert(title: "Error Verifying Phone Number", message: "Please re-enter your phone number on the previous page.")
                    print(error.localizedDescription)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.activityIndicator.stopAnimating()
            }
        }
    }

    func loginWith(credential: PhoneAuthCredential) {
        activityIndicator.startAnimating()
        Auth.auth().signIn(with: credential) { (user, error) in
            self.activityIndicator.stopAnimating()
            if error != nil {
                self.presentAlert(title: "Invalid Code", message: "Please use the correct verification code. If you did not recieve the code tap the \"Resend Code\" button.")
                return
            }
            
            if user != nil {
                let main = UIStoryboard(name: "Main", bundle: nil)
                let additionalDetailsVC = main.instantiateViewController(withIdentifier: "additionalDetailsVC") as! AdditionalDetailsViewController
                
                //TODO: If user has already created an account go directly into app without presenting additional details or asking for permissions
                self.navigationController?.pushViewController(additionalDetailsVC, animated: true)
            }
        }
    }
    
    func verifyCodeLength() -> Bool {
        return tableMeTextField.textField.text?.count == 6
    }
    
    func getLastFourChars(of phoneNumber: String?) -> String {
        var lastFourDigits = ""
        if let phoneNumber = phoneNumber {
            for (index, char) in phoneNumber.enumerated() {
                if index > phoneNumber.count - 5 {
                    lastFourDigits.append(char)
                }
            }
        } else {
            lastFourDigits = "*no phone number"
        }
        return lastFourDigits
    }
    
    func textFieldDidChange() {
        if verifyCodeLength() {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            //print do anything?
        }
        
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
