//
//  PlaceTableViewCell.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
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
