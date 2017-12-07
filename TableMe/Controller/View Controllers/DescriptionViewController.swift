//
//  DescriptionViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 12/7/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class DescriptionViewController: UIViewController, UITextViewDelegate {
    
    let dataStore = DataStore.sharedInstance
    weak var editProfileVC: EditProfileViewController?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = dataStore.description
        textView.becomeFirstResponder()
        textView.delegate = self
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //save description info
        editProfileVC?.changes["description"] = textView.text
        editProfileVC?.newDescription = textView.text
        editProfileVC?.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isEnabled = true
        saveButton.alpha = 1
    }
    
}
