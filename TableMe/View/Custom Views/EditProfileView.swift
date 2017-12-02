//
//  EditProfileView.swift
//  TableMe
//
//  Created by Douglas Galante on 11/27/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class EditProfileView: UIView, TableMeTextFieldDelegate {
    
    var checkBoxSelected = false
    var delegate: CheckBoxDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profilePictureButtonView: TableMeButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fullNameTMTextField: TableMeTextFieldView!
    @IBOutlet weak var emailTMTextField: TableMeTextFieldView!
    @IBOutlet weak var genderTMTextField: TableMeTextFieldView!
    @IBOutlet weak var birthdayTMTextField: TableMeTextFieldView!
    @IBOutlet weak var checkBoxView: UIView!
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("EditProfileView", owner: self, options: nil    )
        self.addSubview(self.contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        setViewValues()
        setDelegates()
        setGestures()
    }
    
    func setDelegates() {
        fullNameTMTextField.delegate = self
        emailTMTextField.delegate = self
        genderTMTextField.delegate = self
        birthdayTMTextField.delegate = self
    }
    
    func setViewValues() {
        checkBoxView.layer.cornerRadius = 2
        checkBoxView.layer.borderWidth = 1
        checkBoxView.layer.borderColor = UIColor.themeGray.cgColor
        
        fullNameTMTextField.textField.tag = 1
        fullNameTMTextField.setTextFieldProperties(title: "Full Name", contentType: .name, capitalization: .words, correction: .no, keyboardType: .default, keyboardAppearance: .dark, returnKey: .next)
        
        emailTMTextField.textField.tag = 2
        emailTMTextField.setTextFieldProperties(title: "Email Address", contentType: .emailAddress, capitalization: .none, correction: .no, keyboardType: .emailAddress, keyboardAppearance: .dark, returnKey: .next)
        
        genderTMTextField.label.text = "Choose Gender"
        genderTMTextField.textField.tag = 3
        
        birthdayTMTextField.label.text = "Choose Birthday"
        birthdayTMTextField.textField.tag = 4
        
        profilePictureButtonView.setProperties(title: "", icon: #imageLiteral(resourceName: "camera"), backgroundImage: nil, backgroundColor: .themeGreen, cornerRadius: 45)
    }
    
    func setGestures() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped))
        checkBoxView.addGestureRecognizer(tapGR)
        checkBoxView.isUserInteractionEnabled = true
    }
    
    @objc func checkBoxTapped(_ sender: UITapGestureRecognizer) {
        switch checkBoxSelected {
        case true:
            checkBoxView.layer.borderColor = UIColor.themeGray.cgColor
            checkBoxView.backgroundColor = UIColor.clear
            checkBoxSelected = false
        case false:
            checkBoxView.layer.borderColor = UIColor.themePurple.cgColor
            checkBoxView.backgroundColor = UIColor.themePurple
            checkBoxSelected = true
        }
        delegate?.checkboxWasTapped()
    }
    
    //TODO: Not the ideal architecture for this... find a better design pattern. Textfield changing shouldnt be attached to the checkbox tapped function
    func textFieldDidChange() {
        delegate?.checkboxWasTapped()
    }

    func validateAllFields() -> Bool {
        var allFieldsValid = true
        if fullNameTMTextField.textField.text!.count < 1 {
            allFieldsValid = false
        }
        if !emailTMTextField.textField.text!.isValidEmail() {
            allFieldsValid = false
        }
        if !checkBoxSelected {
            allFieldsValid = false
        }
        return allFieldsValid
    }
    
    @IBAction func dateButtonTapped(_ sender: UIButton) {
        print("tapped date button")
        birthdayTMTextField.becomeFirstResponder()
    }
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        genderTMTextField.becomeFirstResponder()
    }
    
    
}
