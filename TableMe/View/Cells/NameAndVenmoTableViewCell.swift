//
//  NameAndVenmoTableViewCell.swift
//  TableMe
//
//  Created by Douglas Galante on 12/6/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class NameAndVenmoTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var venmoIDLabel: UILabel!
    
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
