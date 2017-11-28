//
//  TableMeTextFieldView.swift
//  TableMe
//
//  Created by Douglas Galante on 11/28/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class TableMeTextFieldView: UIView {
    
    var textFieldIsRisen = false
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("TableMeTextFieldView", owner: self, options: nil    )
        self.addSubview(self.contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textField.addTarget(self, action: #selector(raiseLabel), for: .editingChanged)
    }
    
    func setText(_ placeholderText: String, labelText: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.themeGray])
        label.text = labelText
    }
    
    func setTextFieldProperties(_ contentType: UITextContentType, capitalization: UITextAutocapitalizationType, correction: UITextAutocorrectionType, keyboardType: UIKeyboardType, keyboardAppearance: UIKeyboardAppearance, inputView: UIView?) {
        textField.textContentType = contentType
        textField.autocapitalizationType = capitalization
        textField.autocorrectionType = correction
        textField.keyboardType = keyboardType
        textField.keyboardAppearance = keyboardAppearance
        if inputView != nil {
            textField.inputView = inputView
        }
    }
    
    @objc func raiseLabel() {
        if textField.text!.count > 0 && !textFieldIsRisen {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.underlineView.backgroundColor = .themePurple
                self.label.alpha = 1
                self.labelBottomConstraint.constant = -10
                self.layoutIfNeeded()
            }, completion: nil)
        } else if textField.text!.count == 0 {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.underlineView.backgroundColor = .themeGray
                self.label.alpha = 0
                self.labelBottomConstraint.constant = 15
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}
