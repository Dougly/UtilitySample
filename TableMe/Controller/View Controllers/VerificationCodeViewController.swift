//
//  VerificationCodeViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/20/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import FirebaseAuth

class VerificationCodeViewController: UIViewController, TableMeTextFieldDelegate, TableMeButtonDelegate {

    let database = FirebaseDatabaseFacade()
    let auth = FirebaseAuthFacade()
    var phoneNumber: String?
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var weSentVerificationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableMeTextField: TableMeTextFieldView!
    @IBOutlet weak var resendTableMeButton: TableMeButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var codeLengthIsValid: Bool {
        return tableMeTextField.textField.text?.count == 6
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNoteLable(with: phoneNumber)
        setResendButtonProperties()
        setTextfieldProperties()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else { return }
        let verificationCode = tableMeTextField.textField.text!
        let credential = auth.getCredentialWith(verificationID: verificationID, verificationCode: verificationCode)
        loginWith(credential: credential)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func resendCodeButtonTapped() {
        if let phoneNumber = phoneNumber {
            activityIndicator.startAnimating()
            auth.getVerificationCodeFor(phoneNumber: phoneNumber) { (verificationID, error) in
                if let error = error {
                    self.activityIndicator.stopAnimating()
                    self.presentAlert(title: "Error Verifying Phone Number", message: "Please re-enter your phone number on the previous page.")
                    print(error.localizedDescription) //is there more than one type of error?
                    return
                } else if let verificationID = verificationID {
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    self.activityIndicator.stopAnimating()
                }
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
                self.presentNextViewController()
            }
        }
    }
    
    func textFieldDidChange() {
        if codeLengthIsValid {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentNextViewController() {
        guard let phoneNumber = phoneNumber else { return }
        database.readValueOnce(at: "users/\(phoneNumber)") { (dict) in
            if let dict = dict {
                if dict["name"] as? String != nil {
                    self.popToRootAndEnterApp()
                } else {
                    self.pushToAdditionalDetails()
                }
            } else {
                self.pushToAdditionalDetails()
            }
        }
    }
    
    func tableMeButtonActivted() {
        resendCodeButtonTapped()
    }
    
    func popToRootAndEnterApp() {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = mainSB.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
        let rootVC = self.navigationController?.viewControllers[0] as! LogInViewController
        let viewControllers = [rootVC, tabBarController]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    func pushToAdditionalDetails() {
        let loginSB = UIStoryboard(name: "Login", bundle: nil)
        let additionalDetailsVC = loginSB.instantiateViewController(withIdentifier: "additionalDetailsVC") as! AdditionalDetailsViewController
        self.navigationController?.pushViewController(additionalDetailsVC, animated: true)
    }
    
    func setNoteLable(with phoneNumber: String?) {
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
        self.weSentVerificationLabel.text = "We sent you a 6 digit code to cell number ending in \(lastFourDigits). Please enter it below."
    }

    func setResendButtonProperties() {
        resendTableMeButton.setProperties(title: "Resend Code", icon: nil, backgroundImage: nil, backgroundColor: .black, cornerRadius: nil)
        resendTableMeButton.labelUnderline.isHidden = false
        resendTableMeButton.labelUnderline.backgroundColor = .themeGray
        resendTableMeButton.titleLabel.textColor = .themeGray
        resendTableMeButton.titleLabel.font = UIFont(name: "Avenir", size: 15)
        resendTableMeButton.delegate = self
    }
    
    func setTextfieldProperties() {
        tableMeTextField.setTextFieldProperties(title: "6 Digit Code", contentType: nil, capitalization: .none, correction: .no, keyboardType: .numberPad, keyboardAppearance: .dark, returnKey: .done)
        tableMeTextField.textField.maxLength = 6
        tableMeTextField.delegate = self
        
    }
    
}
