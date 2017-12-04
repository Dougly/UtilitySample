//
//  EditProfileViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 12/1/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import Kingfisher

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let auth = FirebaseAuthFacade()
    let databse = FirebaseDatabaseFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let phoneNumber = auth.getCurrentUser()?.phoneNumber {
            databse.readValueOnce(at: "users/\(phoneNumber)") { (userInfo) in
                guard let userInfo = userInfo else { return }
                print(userInfo)
                let urlString = userInfo["profileImage"] as! String
                let url = URL(string: urlString)
                self.imageView.kf.setImage(with: url)
            }
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        print("logout tapped")
        auth.logout { (success, error) in
            if success {
                self.navigationController?.popToRootViewController(animated: true)
            } else if let error = error {
                print(error)
            }
        }
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
