//
//  TextFieldTableViewCell.swift
//  TableMe
//
//  Created by Douglas Galante on 12/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.selectionStyle = .none
    }
    
}
