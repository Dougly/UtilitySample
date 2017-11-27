//
//  EditProfileView.swift
//  TableMe
//
//  Created by Douglas Galante on 11/27/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class EditProfileView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var fullNameUnderline: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailUnderline: UIView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderSelectionButton: UIButton!
    @IBOutlet weak var genderUnderline: UIView!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdaySelectionButton: UIButton!
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
    }
}
