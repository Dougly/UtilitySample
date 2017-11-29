//
//  TableMeButton.swift
//  TableMe
//
//  Created by Douglas Galante on 11/29/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

enum TableMeButtonState {
    case pressed, released
}

class TableMeButton: UIView {
    
    
    var longTouchStartingPoint = CGPoint(x: 0, y: 0)
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonEdgesView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var buttonEdgeLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonEdgeTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonEdgeTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonEdgeBottomConstraint: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("TableMeButton", owner: self, options: nil    )
        self.addSubview(self.contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        addGestures()
    }
    
    func addGestures() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedButton))
        let longGR = UILongPressGestureRecognizer(target: self, action: #selector(longHold))
        longGR.minimumPressDuration = 0.1
        contentView.addGestureRecognizer(tapGR)
        contentView.addGestureRecognizer(longGR)
        
        
//        let panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
//        contentView.addGestureRecognizer(panGR)
        
    }
    
    @objc func longHold(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.longTouchStartingPoint = sender.location(in: self)
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0.5
                self.buttonEdgeTopConstraint.constant = 5
                self.buttonEdgeBottomConstraint.constant = -5
                self.buttonEdgeLeadingConstraint.constant = 5
                self.buttonEdgeTrailingConstraint.constant = -5
                self.layoutIfNeeded()
            })
        }
        
        if sender.state == .changed {
            let xLocation = sender.location(in: self).x
            let yLocation = sender.location(in: self).y
            
            let maxXOffset = self.frame.width + 40
            let minXOffset: CGFloat = -40
            
            let maxYOffset = self.frame.height + 40
            let minYOffset: CGFloat = -40
            
            if xLocation > maxXOffset || xLocation < minXOffset || yLocation > maxYOffset || yLocation < minYOffset {
                sender.isEnabled = false
            }
        }

        
        if sender.state == .cancelled {
            animateToStartingPosition()
            sender.isEnabled = true
        }
        
        if sender.state == .ended {
            animateToStartingPosition()
            //perfrom action
        }
    }
    
    func animateToStartingPosition() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
            self.buttonEdgeTopConstraint.constant = 0
            self.buttonEdgeBottomConstraint.constant = 0
            self.buttonEdgeLeadingConstraint.constant = 0
            self.buttonEdgeTrailingConstraint.constant = 0
            self.layoutIfNeeded()
        })
    }
    
    @objc func tappedButton(_ sender: UITapGestureRecognizer) {
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [.calculationModeCubicPaced], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                self.buttonEdgeTopConstraint.constant = 5
                self.buttonEdgeBottomConstraint.constant = -5
                self.buttonEdgeLeadingConstraint.constant = 5
                self.buttonEdgeTrailingConstraint.constant = -5
                self.layoutIfNeeded()
            })

            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1, animations: {
                self.buttonEdgeTopConstraint.constant = 0
                self.buttonEdgeBottomConstraint.constant = 0
                self.buttonEdgeLeadingConstraint.constant = 0
                self.buttonEdgeTrailingConstraint.constant = 0
                self.layoutIfNeeded()
            })
        }) { (success) in
            //potentially do something
        }
    }
    
    
    
    func setProperties(title: String, icon: UIImage, backgroundImage: UIImage, backgroundColor: UIColor) {
        self.titleLabel.text = title
        self.iconImageView.image = icon
        self.backgroundImageView.image = backgroundImage
        self.buttonEdgesView.backgroundColor = backgroundColor
    }

    
}
