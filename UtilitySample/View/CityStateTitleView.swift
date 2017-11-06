//
//  CityStateTitleView.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class CityStateTitleView: UIView {
    
    let arrowSpacing: CGFloat = 10
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var cityStateLabelCenterX: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("CityStateTitleView", owner: self, options: nil    )
        self.addSubview(self.contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        let cityStateOffset = arrowSpacing + downArrowImageView.frame.width * -1
        cityStateLabelCenterX.constant = cityStateOffset
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        print("tapped Filter")
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        print("tapped Profile")
    }
    
    func setTitle(city: String, state: String) {
        self.cityStateLabel.text = "\(city.capitalized), \(state.uppercased())"
    }
    
}
