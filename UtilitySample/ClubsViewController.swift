//
//  ClubsViewController.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ClubsViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setNavigationBar() {
        guard let navBar = self.navigationController else { return }
        navBar.isNavigationBarHidden = false
        
    }
    
    func setTabBar() {
    }
}
