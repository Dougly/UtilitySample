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
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var thisIsTableMeLabel: UILabel!
    @IBOutlet weak var signUpWithPhoneNumberButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        adjustFontScales()
        //applyGradient()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        applyGradient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func adjustFontScales() {
        signUpWithPhoneNumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpWithPhoneNumberButton.titleLabel?.minimumScaleFactor = 0.5
        welcomeLabel.font = thisIsTableMeLabel.font
        
    }
    
    func applyGradient() {
        let startingColorOfGradient = UIColor(red: 133/255, green: 54/255, blue: 229/255, alpha: 1)
        let endingColorOFGradient = UIColor(red: 9/255, green: 206/255, blue: 170/255, alpha: 1)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        print(gradient.frame)
        gradient.colors = [startingColorOfGradient , endingColorOFGradient]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.view.layer.insertSublayer(gradient, at: 0)
        
    }


}

