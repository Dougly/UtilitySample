//
//  UITextFieldExtension.swift
//  TableMe
//
//  Created by Douglas Galante on 11/20/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return Int.max // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
        textField.delegate?.textFieldDidBeginEditing?(textField)
    }
}
