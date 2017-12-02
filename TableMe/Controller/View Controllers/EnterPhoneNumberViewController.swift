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
    
    let auth = FirebaseAuthFacade()
    var charCount = 0
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableMeTextField: TableMeTextFieldView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var userInputIsCorrectLength: Bool {
        return tableMeTextField.textField.text?.count == 14
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextfieldProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableMeTextField.textField.becomeFirstResponder()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        tableMeTextField.textField.resignFirstResponder()
        presentAlert()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidChange() {
        guard let textField = tableMeTextField.textField else { return }
        autoFormatPhoneNumberText(in: textField)
        if userInputIsCorrectLength {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func checkForValidPhoneNumber() -> (isValid: Bool, phoneNumber: String) {
        self.activityIndicator.startAnimating()
        var phoneNumber = "+1"
        let chars = Array(self.tableMeTextField.textField.text!)
        for char in chars {
            switch char {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                phoneNumber.append(char)
            default:break
            }
        }
        return (phoneNumber.count == 12, phoneNumber)
    }
    
    func loginWith(phoneNumber: String) {
        auth.getVerificationCodeFor(phoneNumber: phoneNumber) { verID, error in
            if let error = error {
                self.activityIndicator.stopAnimating()
                print(error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verID, forKey: "authVerificationID")
            let loginSB = UIStoryboard(name: "Login", bundle: nil)
            let verificationCodeVC = loginSB.instantiateViewController(withIdentifier: "verificationCodeVC") as! VerificationCodeViewController
            verificationCodeVC.phoneNumber = phoneNumber
            self.navigationController?.pushViewController(verificationCodeVC, animated: true)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Rates May Apply", message: "Signing up with your phone number will send a text message to your phone. Standard rates may apply.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (alertAction) in
            let phone = self.checkForValidPhoneNumber()
            if phone.isValid {
                self.loginWith(phoneNumber: phone.phoneNumber)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setTextfieldProperties() {
        tableMeTextField.delegate = self
        tableMeTextField.textField.maxLength = 14
        tableMeTextField.setTextFieldProperties(title: "PhoneNumber", contentType: .telephoneNumber, capitalization: .none, correction: .no, keyboardType: .numberPad, keyboardAppearance: .dark, returnKey: .done)
    }
    
    func autoFormatPhoneNumberText(in textField: UITextField) {
        guard let count = textField.text?.count else { return }
        if count == 10 && charCount < count {
            let lastDigit = String(textField.text!.removeLast())
            let first3Digits = textField.text!
            let newString = first3Digits + "-" + lastDigit
            textField.text = newString
        } else if count == 5 {
            var newString = ""
            for char in textField.text! {
                switch char {
                case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                    newString.append(char)
                default:
                    break
                }
            }
            newString.removeLast()
            textField.text = newString
        } else if count == 10  {
            var newString = textField.text!
            newString.removeLast()
            textField.text = newString
        } else if charCount < count {
            switch count {
            case 3:
                let areaCode = textField.text!
                let newString = "(\(areaCode)) "
                textField.text = newString
            case 9:
                let newString = textField.text! + "-"
                textField.text = newString
            default: break
            }
        }
        charCount = textField.text!.count
    }
    
}
