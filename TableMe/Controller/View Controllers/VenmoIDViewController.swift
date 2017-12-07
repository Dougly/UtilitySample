//
//  VenmoIDViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 12/7/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class VenmoIDViewController: UIViewController, TableMeTextFieldDelegate, UITextFieldDelegate {
    
    let dataStore = DataStore.sharedInstance
    weak var editProfileVC: EditProfileViewController?
    weak var tableView: UITableView?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var tableMeTextField: TableMeTextFieldView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableMeTextField.setTextFieldProperties(title: "Username", contentType: .none, capitalization: .none, correction: .no, keyboardType: .alphabet, keyboardAppearance: .dark, returnKey: .done)
        tableMeTextField.delegate = self
        tableMeTextField.textField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableMeTextField.textField.becomeFirstResponder()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let venmoID = tableMeTextField.textField.text!
        dataStore.venmoID = venmoID
        editProfileVC?.changes["venmoID"] = venmoID
        tableView?.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidChange() {
        addCommercialAt()
    }
    
    func addCommercialAt() {
        if let text = tableMeTextField.textField.text {
            if text.count > 0 && text.first! != "@" {
                let string = "@" + text
                tableMeTextField.textField.text = string
            } else {
                saveButton.isEnabled = true
                saveButton.alpha = 1
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.saveButtonTapped(textField)
        return true
    }
}
