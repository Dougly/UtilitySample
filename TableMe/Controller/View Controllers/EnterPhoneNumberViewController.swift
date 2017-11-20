//
//  EnterPhoneNumberViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/20/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import FirebaseAuth

class EnterPhoneNumberViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
        textField.addTarget(self, action: #selector(textFieldDidChange),
                            for: .editingChanged)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        presentAlert()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        print("tapped back button")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        underlineView.backgroundColor = .themePurple
        phoneNumberLabel.textColor = .white
       
        switch Int(textField.text!.count) {
        case 3, 9:
            let text = textField.text!
            textField.text = text + " - "
        default:
            break
        }
        
        if verifyPhoneNumber() {
            nextButton.titleLabel?.textColor = .white
        } else {
            nextButton.titleLabel?.textColor = .themeGray
        }
    }
    
    func verifyPhoneNumber() -> Bool {
        return textField.text?.count == 16
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Rates May Apply", message: "Signing up with your phone number will send a text message to your phone. Standard rates may apply", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (alertAction) in
           
            var phoneNumber = ""
            
            let chars = Array(self.textField.text!)
            for char in chars {
                switch char {
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    phoneNumber.append(char)
                default:
                    break
                }
            }
            
            
            if phoneNumber.count == 10 {
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, completion: { (verificationID, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    
                    // present and pass id to verification page
                    let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verificationCodeVC") as! VerificationCodeViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
                })
                //send number to firebase
                
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (cancelAction) in
            //dismiss?
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
}
