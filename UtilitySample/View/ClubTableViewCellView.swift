//
//  ClubTableViewCellView.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ClubTableViewCellView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tablesAvailableLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costAndActivitiesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ClubTableViewCellView", owner: self, options: nil)
        self.addSubview(self.contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
    }
    
    func updateLabelsAndImage(tables: String, distance: String, name: String, cost: String, activities: [String], address: String, image: UIImage) {
        
        self.tablesAvailableLabel.text = "\(tables) TABLES AVAILABLE"
        self.distanceLabel.text = "\(distance)mi"
        self.nameLabel.text = name.capitalized
        
        var costAndActivitiesString = "\(cost)"
        if !activities.isEmpty {
            costAndActivitiesString.append(" - ")
            for (i, activity) in activities.enumerated() {
                costAndActivitiesString.append("\(activity.capitalized)")
                if i != activities.count - 1 {
                    costAndActivitiesString.append(", ")
                }
            }
        }
        self.costAndActivitiesLabel.text = costAndActivitiesString
        self.addressLabel.text = address
        self.imageView.image = image
    }
    
}




