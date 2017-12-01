//
//  ViewController.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/4/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, TableMeButtonDelegate {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var performAnimation = true
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var thisIsTableMeLabel: UILabel!
    @IBOutlet weak var tableMeButton: TableMeButton!
    @IBOutlet weak var logoCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var welcomeLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var thisIsTableMeCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableMeButtonCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        welcomeLabel.font = thisIsTableMeLabel.font
        setupForOpeningAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupButton()
        if performAnimation {
            openingAnimation()
        }
    }
    
    func setupButton() {
        let startingColorOfGradient = UIColor.themeGreen.cgColor
        let endingColorOFGradient = UIColor.themePurple.cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = tableMeButton.buttonEdgesView.bounds
        gradient.bounds = tableMeButton.buttonEdgesView.bounds
        gradient.colors = [endingColorOFGradient, startingColorOfGradient]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        tableMeButton.buttonEdgesView.layer.insertSublayer(gradient, at: 0)
        tableMeButton.layer.cornerRadius = 5
        tableMeButton.clipsToBounds = true
        tableMeButton.titleLabel.text = "Sign in with Phone Number"
        tableMeButton.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tableMeButton.titleLabel.textColor = .white
        tableMeButton.delegate = self
    }
    
    func buttonActivted() {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let destVC = main.instantiateViewController(withIdentifier: "enterPhoneVC")
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func enterAppAfterLogin() {
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let destVC = main.instantiateViewController(withIdentifier: "mainTabBar")
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func setupForOpeningAnimation() {
        logoImageView.alpha = 1
        thisIsTableMeLabel.alpha = 0
        welcomeLabel.alpha = 0
        tableMeButton.alpha = 0
        tableMeButtonCenterXConstraint.constant = 30
        thisIsTableMeCenterXConstraint.constant = 100
        welcomeLabelCenterXConstraint.constant = 0
        thisIsTableMeCenterXConstraint.constant = 0
    }
    
    func openingAnimation() {
        let screenWidth = UIScreen.main.bounds.width
        let logoAnimationDistance = ((screenWidth / 2) - (logoImageView.frame.width / 2) - 15) * -1
        let welcomeAnimationDistance = ((screenWidth / 2) - (welcomeLabel.frame.width / 2) - 15) * -1
        let thisIsTableMeAnimationDistance = ((screenWidth / 2) - (thisIsTableMeLabel.frame.width / 2) - 15) * -1
        
        UIView.animateKeyframes(withDuration: 1.2, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3, animations: {
                self.logoCenterXConstraint.constant = logoAnimationDistance
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3, animations: {
                self.welcomeLabelCenterXConstraint.constant = welcomeAnimationDistance
                self.welcomeLabel.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3, animations: {
                self.thisIsTableMeCenterXConstraint.constant = thisIsTableMeAnimationDistance
                self.thisIsTableMeLabel.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.3, animations: {
                self.tableMeButtonCenterXConstraint.constant = 0
                self.tableMeButton.alpha = 1.0
            })
            
            self.view.layoutIfNeeded()
            
        }, completion: { success in
            self.performAnimation = false
        })
    }

}

