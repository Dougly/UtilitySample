//
//  EnterPhoneNumberViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/20/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import FirebaseAuth

class EnterPhoneNumberViewController: UIViewController, TableMeTextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableMeTextField: TableMeTextFieldView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableMeTextField.set(labelText: "Phone Number")
        tableMeTextField.delegate = self
        tableMeTextField.setTextFieldProperties(UITextContentType.telephoneNumber, capitalization: .none, correction: .no, keyboardType: .numberPad, keyboardAppearance: .dark, returnKey: .done)
//        textField.becomeFirstResponder()
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        presentAlert()
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func verifyPhoneNumber() -> Bool {
        return tableMeTextField.textField.text?.count == 16
    }
    
    func textFieldDidChange() {
        guard let textField = tableMeTextField.textField else { return }
        switch Int(textField.text!.count) {
        case 3, 9:
            let text = textField.text!
            textField.text = text + " - "
        default:
            break
        }
        
        if verifyPhoneNumber() {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Rates May Apply", message: "Signing up with your phone number will send a text message to your phone. Standard rates may apply", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (alertAction) in
            self.activityIndicator.startAnimating()

            var phoneNumber = "+1"
            let chars = Array(self.tableMeTextField.textField.text!)
            for char in chars {
                switch char {
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    phoneNumber.append(char)
                default:
                    break
                }
            }
            
            if phoneNumber.count == 12 {
                PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        self.activityIndicator.stopAnimating()
                        print(error.localizedDescription)
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "verificationCodeVC") as! VerificationCodeViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
}
