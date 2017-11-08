//
//  ViewController.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/4/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var thisIsTableMeLabel: UILabel!
    @IBOutlet weak var signUpWithPhoneNumberButton: UIButton!
    
    @IBOutlet weak var logoCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var welcomeLabelCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var thisIsTableMeCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var signUpButtonCenterXConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        adjustFontScales()
        setupForOpeningAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openingAnimation()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyGradient()
        
    }

    func adjustFontScales() {
        signUpWithPhoneNumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpWithPhoneNumberButton.titleLabel?.minimumScaleFactor = 0.5
        welcomeLabel.font = thisIsTableMeLabel.font
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        closingAnimation()
    }
    
    func applyGradient() {
        let startingColorOfGradient = UIColor(red: 133/255, green: 54/255, blue: 229/255, alpha: 1).cgColor
        let endingColorOFGradient = UIColor(red: 9/255, green: 206/255, blue: 170/255, alpha: 1).cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = signUpWithPhoneNumberButton.bounds
        gradient.bounds = signUpWithPhoneNumberButton.bounds
        gradient.colors = [startingColorOfGradient , endingColorOFGradient]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.signUpWithPhoneNumberButton.layer.insertSublayer(gradient, at: 0)
        
        signUpWithPhoneNumberButton.layer.cornerRadius = 5
        signUpWithPhoneNumberButton.clipsToBounds = true
    }
    
    func setupForOpeningAnimation() {
        thisIsTableMeLabel.alpha = 0
        welcomeLabel.alpha = 0
        signUpWithPhoneNumberButton.alpha = 0
        signUpButtonCenterXConstraint.constant = 30
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
                self.signUpButtonCenterXConstraint.constant = 0
                self.signUpWithPhoneNumberButton.alpha = 1.0
            })
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    func closingAnimation() {
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
                self.logoCenterXConstraint.constant -= 30
                self.logoImageView.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.welcomeLabelCenterXConstraint.constant -= 30
                self.welcomeLabel.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                self.thisIsTableMeCenterXConstraint.constant -= 30
                self.thisIsTableMeLabel.alpha = 0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: {
                self.signUpWithPhoneNumberButton.alpha = 0
            })
            
            self.view.layoutIfNeeded()
            
        }) { (success) in
            self.performSegue(withIdentifier: "signIn", sender: self)
        }
    }


}

