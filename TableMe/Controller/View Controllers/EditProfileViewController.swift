//
//  EditProfileViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 12/1/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import Kingfisher

enum EditProfileCellType {
    case picture, textfield, description, additional, venmo, single
}

class EditProfileViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var titleLabelYDistance: CGFloat = 0
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editProfileLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var editProfileTopConstraint: NSLayoutConstraint!
    
    let auth = FirebaseAuthFacade()
    let dataStore = DataStore.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabelYDistance = (editProfileLabel.frame.height / 2) + (backButton.frame.height / 2) + 15.0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0)

        
        //let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.tableViewBottomConstraint.constant = keyboardHeight * -1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillDisappear() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.tableViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
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
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 7: return 100
        case 1, 2, 3, 4, 5: return 85
        case 6, 8, 9, 10: return 80
        default: return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cellType: EditProfileCellType = .single
    
        switch row {
        case 0: cellType = .picture
        case 1, 2, 3, 4: cellType = .textfield
        case 5: cellType = .description
        case 6: cellType = .venmo
        case 7: cellType = .additional
        case 8, 9, 10: cellType = .single
        default: break
        }
        
        switch cellType {
        case .picture:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pictureTableViewCell") as! PictureTableViewCell
            cell.tableMeButton.setProperties(title: nil, icon: nil, backgroundImage: nil, backgroundColor: .clear, cornerRadius: 43)
            let url = URL(string: dataStore.userInfo["profileImage"] as! String)
            cell.tableMeButton.backgroundImageView.kf.setImage(with: url)
            return cell
        case .textfield:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldTableViewCell") as! TextFieldTableViewCell
            self.setPropertiesFor(textfieldCell: cell, row: row)
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionTableViewCell") as! DescriptionTableViewCell
            cell.textLabel?.text = dataStore.description
            return cell
        case .venmo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "venmoIDTableViewCell") as! VenmoIDTableViewCell
            cell.venmoIDLabel.text = dataStore.venmoID
            return cell
        case .additional:
            let cell = tableView.dequeueReusableCell(withIdentifier: "additionalDetailsTableViewCell")
            cell?.selectionStyle = .none
            return cell!
        case .single:
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOptionTableViewCell") as! SingleOptionTableViewCell
            self.setPropertiesFor(singleOptionCell: cell, row: row)
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let baseTopConstant: CGFloat = 15
        let titleLabelXDistance: CGFloat = (view.frame.width / 2) - (editProfileLabel.frame.width / 2) - 40
        let baseLeadingConstant: CGFloat = 15
        
        if offset > -65 && offset < (titleLabelYDistance - 65) {
            let increment = (offset + 65) * 0.5
            let scaleFraction = (65 - increment) / 65
            let xFraction = titleLabelXDistance / titleLabelYDistance
            editProfileLabel.transform = CGAffineTransform(scaleX: scaleFraction, y: scaleFraction)
            editProfileTopConstraint.constant = baseTopConstant - (offset + 65)
            editProfileLeadingConstraint.constant = baseLeadingConstant + ((offset + 65) * xFraction)
        } else if offset > (titleLabelYDistance - 65) {
            let increment = (titleLabelYDistance) * 0.5
            let scaleFraction = (65 - increment) / 65
            editProfileLabel.transform = CGAffineTransform(scaleX: scaleFraction, y: scaleFraction)
            editProfileTopConstraint.constant = baseTopConstant - (titleLabelYDistance)
            editProfileLeadingConstraint.constant = baseLeadingConstant + titleLabelXDistance
        } else if offset < -65 && editProfileTopConstraint.constant == baseTopConstant {
            let increment = (-65 - offset) / 8
            let scale = (65 + increment) / 65
            editProfileLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
            editProfileLeadingConstraint.constant = baseLeadingConstant + increment
        } else {
            editProfileLabel.transform = CGAffineTransform.identity
            editProfileTopConstraint.constant = baseTopConstant
            editProfileLeadingConstraint.constant = baseLeadingConstant
        }
    }
    
    func setPropertiesFor(textfieldCell: TextFieldTableViewCell, row: Int) {
        switch row {
        case 1:
            textfieldCell.titleLabel.text = "Full Name"
            textfieldCell.textField.text = dataStore.name
        case 2:
            textfieldCell.titleLabel.text = "Email"
            textfieldCell.textField.text = dataStore.email
        case 3:
            textfieldCell.titleLabel.text = "Phone Number"
            textfieldCell.textField.text = dataStore.phoneNumber
        case 4:
            textfieldCell.titleLabel.text = "Gender"
            textfieldCell.textField.text = dataStore.gender
        default:
            break
        }
    }
    
    func setPropertiesFor(singleOptionCell: SingleOptionTableViewCell, row: Int) {
        switch row {
        case 8: singleOptionCell.optionTitleLabel.text = "Support"
        case 9: singleOptionCell.optionTitleLabel.text = "Terms & Conditions"
        case 10: singleOptionCell.optionTitleLabel.text = "Log Out"
        default: break
        }
    }
    
    
    
    func offsetScrollViewFor(view: UIView) {
        var yOffset: CGFloat = 0
        switch view.tag {
        case 1: yOffset = 0
        case 2: yOffset = 86.5
        case 3: yOffset = 173
        case 4: yOffset = 259.5
        default: break
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
//            self.scrollView.contentOffset = CGPoint(x: 0.0, y: yOffset)
//            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


    
    

