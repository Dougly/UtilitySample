//
//  ViewController.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/4/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var thisIsTableMeLabel: UILabel!
    @IBOutlet weak var signUpWithPhoneNumberButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        adjustFontScales()
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


}

