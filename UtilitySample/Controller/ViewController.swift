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
    @IBOutlet weak var gradientView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        adjustFontScales()
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
        UIView.animate(withDuration: 0.3, animations: {
            self.logoImageView.alpha = 0
            self.welcomeLabel.alpha = 0
            self.thisIsTableMeLabel.alpha = 0
            self.signUpWithPhoneNumberButton.alpha = 0
            self.gradientView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (success) in
            self.performSegue(withIdentifier: "signIn", sender: self)
        }
    }
    
    func applyGradient() {
        let startingColorOfGradient = UIColor(red: 133/255, green: 54/255, blue: 229/255, alpha: 1).cgColor
        let endingColorOFGradient = UIColor(red: 9/255, green: 206/255, blue: 170/255, alpha: 1).cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.bounds = gradientView.bounds
        gradient.colors = [startingColorOfGradient , endingColorOFGradient]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.gradientView.layer.insertSublayer(gradient, at: 0)
        
        gradientView.layer.cornerRadius = 5
        gradientView.clipsToBounds = true
    }


}

