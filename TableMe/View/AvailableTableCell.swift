//
//  AvailableTableCell.swift
//  TableMe
//
//  Created by Douglas Galante on 11/9/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class AvailableTableCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numSeatsLabel: UILabel!
    
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
        self.contentView.backgroundColor = .black
    }
    
}
