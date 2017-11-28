//
//  EditProfileView.swift
//  TableMe
//
//  Created by Douglas Galante on 11/27/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class EditProfileView: UIView {
    
    var checkBoxSelected = false
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fullNameTMTextField: TableMeTextFieldView!
    @IBOutlet weak var emailTMTextField: TableMeTextFieldView!
    @IBOutlet weak var genderTMTextField: TableMeTextFieldView!
    @IBOutlet weak var birthdayTMTextField: TableMeTextFieldView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var certifyLabel: UILabel!
    @IBOutlet weak var certifyView: UIView!
    
    
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
        setGestures()
    }
    
    func setViewValues() {
        profileImageView.layer.cornerRadius = 45
        checkBoxView.layer.cornerRadius = 2
        checkBoxView.layer.borderWidth = 1
        checkBoxView.layer.borderColor = UIColor.themeGray.cgColor
        
        fullNameTMTextField.setText("Full Name", labelText: "Full Name")
        fullNameTMTextField.textField.tag = 1
        fullNameTMTextField.setTextFieldProperties(.name, capitalization: .none, correction: .no, keyboardType: .default, keyboardAppearance: .dark, returnKey: .next)
        
        emailTMTextField.setText("Email Address", labelText: "Email Address")
        emailTMTextField.textField.tag = 2
        emailTMTextField.setTextFieldProperties(.emailAddress, capitalization: .none, correction: .no, keyboardType: .emailAddress, keyboardAppearance: .dark, returnKey: .next)
        
        genderTMTextField.setText("Choose Gender", labelText: "Choose Gender")
        genderTMTextField.textField.tag = 3
        
        birthdayTMTextField.setText("Choose Birthday", labelText: "Choose Birthday")
        birthdayTMTextField.textField.tag = 4
        
    }
    
    func setGestures() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped))
//        let labelTapGR = UITapGestureRecognizer(target: self, action: #selector(checkBoxTapped))
        checkBoxView.addGestureRecognizer(tapGR)
        certifyLabel.addGestureRecognizer(tapGR)
        certifyView.addGestureRecognizer(tapGR)
        checkBoxView.isUserInteractionEnabled = true
        certifyLabel.isUserInteractionEnabled = true
        certifyView.isUserInteractionEnabled = true
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
    }
    
}
