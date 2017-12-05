//
//  EditProfileViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 12/1/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import Kingfisher

class PictureTableViewCell: UITableViewCell {
    @IBOutlet weak var tableMeButton: TableMeButton!
}

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    
}

class DescriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var underlineView: UIView!
}

class VenmoIDTableViewCell: UITableViewCell {
    @IBOutlet weak var venmoIDLabel: UILabel!
}

class SingleOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var optionTitleLabel: UILabel!
}


class EditProfileViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profilePictureTableMeButton: TableMeButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
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
                self.profilePictureTableMeButton.backgroundImageView.kf.setImage(with: url)
            }
        }
       
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
                self.scrollViewBottomConstraint.constant = keyboardHeight * -1
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillDisappear() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
            self.scrollViewBottomConstraint.constant = 0
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

extension EditProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
//        if size.height != descriptionViewHeightConstraint.constant && size.height > textView.frame.size.height{
//            descriptionViewHeightConstraint.constant = size.height
//            textView.setContentOffset(CGPoint.zero, animated: false)
//        }
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
    
    

