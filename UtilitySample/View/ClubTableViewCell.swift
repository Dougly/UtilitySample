//
//  ClubTableViewCell.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ClubTableViewCell: UITableViewCell {
    
    let clubTableViewCellView = ClubTableViewCellView()
    
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
        self.contentView.addSubview(clubTableViewCellView)
        clubTableViewCellView.translatesAutoresizingMaskIntoConstraints = false
        clubTableViewCellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        clubTableViewCellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        clubTableViewCellView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        clubTableViewCellView.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
    }
}
