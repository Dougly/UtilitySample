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
    var delegate: PlaceUIDelegate?
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cityStateLabel: UILabel!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var cityStateLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    
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
        delegate?.showFilter()
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        print("tapped Profile")
    }
    
    @IBAction func dropDownButtonTapped(_ sender: Any) {
        changeViews()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        changeViews()
    }
    
    func setTitle(city: String, state: String) {
        self.cityStateLabel.text = "\(city.capitalized), \(state.uppercased())"
    }
    
    func changeViews() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            if self.cityStateLabel.alpha == 1.0 {
                self.delegate?.revealPlaces()
                self.cityStateLabel.alpha = 0
                self.filterButton.alpha = 0
                self.profileButton.alpha = 0
                self.downArrowImageView.alpha = 0
                self.dropDownButton.alpha = 0
                self.cityLabel.alpha = 1
                self.cancelButton.alpha = 1
            } else {
                self.delegate?.hidePlaces()
                self.cityStateLabel.alpha = 1
                self.filterButton.alpha = 1
                self.profileButton.alpha = 1
                self.downArrowImageView.alpha = 1
                self.dropDownButton.alpha = 1
                self.cityLabel.alpha = 0
                self.cancelButton.alpha = 0
            }
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
}
