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
    @IBOutlet weak var underlineHighlightView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineHighlightTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var underlineHighlightLeadingConstraint: NSLayoutConstraint!
    
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
        setGesturesAndTargets()

    }
    
    func setGesturesAndTargets() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        self.addGestureRecognizer(tapGR)
        self.isUserInteractionEnabled = true
        textField.addTarget(self, action: #selector(raiseLabel), for: [.editingDidEnd, .editingDidBegin])
    }
    
    @objc func tappedView() {
        textField.becomeFirstResponder()
    }
    
    func setText(_ placeholderText: String, labelText: String) {
        //textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.themeGray])
        label.text = labelText
    }
    
    func setTextFieldProperties(_ contentType: UITextContentType?, capitalization: UITextAutocapitalizationType, correction: UITextAutocorrectionType, keyboardType: UIKeyboardType, keyboardAppearance: UIKeyboardAppearance, returnKey: UIReturnKeyType) {
        if contentType != nil { textField.textContentType = contentType! }
        textField.autocapitalizationType = capitalization
        textField.autocorrectionType = correction
        textField.keyboardType = keyboardType
        textField.keyboardAppearance = keyboardAppearance
        textField.returnKeyType = returnKey
    }
    
    @objc func raiseLabel() {
        if !textFieldIsRisen {
            let halfWidth = self.underlineView.frame.width / 2
            UIView.animate(withDuration: 0.4, animations: {
                self.underlineHighlightTrailingConstraint.constant = halfWidth
                self.underlineHighlightLeadingConstraint.constant = -1 * halfWidth
                self.layoutIfNeeded()
            })
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.labelBottomConstraint.constant = -10
                self.label.font = UIFont.systemFont(ofSize: 14)
                self.layoutIfNeeded()
            }, completion: { succes in
                self.textFieldIsRisen = true
            })
            
        } else if textField.text!.count == 0 {
            UIView.animate(withDuration: 0.4, animations: {
                self.underlineHighlightTrailingConstraint.constant = 0
                self.underlineHighlightLeadingConstraint.constant = 0
                self.layoutIfNeeded()
            })
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                self.labelBottomConstraint.constant = 15
                self.label.font = UIFont.systemFont(ofSize: 16)
                self.layoutIfNeeded()
            }, completion:{ succes in
                self.textFieldIsRisen = false
            })
        }
    }
    
}
