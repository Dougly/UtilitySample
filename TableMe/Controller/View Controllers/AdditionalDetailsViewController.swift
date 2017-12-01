//
//  AdditionalDetailsViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/27/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class AdditionalDetailsViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let database = FirebaseDatabaseFacade()
    let genderOptions = ["Male", "Female", "Other"]
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionalDetailsView: EditProfileView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        setupDatePicker()
        setupGenderPicker()
        setDelegates()
    }

    func setDelegates() {
        additionalDetailsView.fullNameTMTextField.textField.delegate = self
        additionalDetailsView.emailTMTextField.textField.delegate = self
        additionalDetailsView.genderTMTextField.textField.delegate = self
        additionalDetailsView.birthdayTMTextField.textField.delegate = self
        additionalDetailsView.profilePictureButtonView.delegate = self
        additionalDetailsView.delegate = self
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
    
    func offsetScrollViewFor(textfield: UITextField) {
        var yOffset: CGFloat = 0
        switch textfield.tag {
        case 1: yOffset = 0
        case 2: yOffset = 86.5
        case 3: yOffset = 173
        case 4: yOffset = 259.5
        default: break
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
            self.scrollView.contentOffset = CGPoint(x: 0.0, y: yOffset)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: UIButton) {
        let name = additionalDetailsView.fullNameTMTextField.textField.text!
        let email = additionalDetailsView.emailTMTextField.textField.text!
        let gender = additionalDetailsView.genderTMTextField.textField.text!
        let birthday = additionalDetailsView.birthdayTMTextField.textField.text!
        database.saveUserInfo(name, email: email, gender: gender, birthday: birthday, profileImageURL: nil)
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let permissionVC = main.instantiateViewController(withIdentifier: "permissionVC") as! PermissionsViewController
        permissionVC.permissionVCType = .notification
        permissionVC.title = "Notifications"
        permissionVC.image = #imageLiteral(resourceName: "notificationGraphic")
        permissionVC.note = "In order to keep you up to date with plans and tables we will need to send you notifications."
        //self.present(permissionVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(permissionVC, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
    }
}

//MARK: Camera And Photo
extension AdditionalDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TableMeButtonDelegate {
    
    func buttonActivted() {
        let textFields = [additionalDetailsView.fullNameTMTextField.textField, additionalDetailsView.emailTMTextField.textField, additionalDetailsView.genderTMTextField.textField, additionalDetailsView.birthdayTMTextField.textField ]
        for textField in textFields {
            if let textField = textField {
                if textField.isFirstResponder {
                    textField.resignFirstResponder()
                }
            }
        }
        presentPhotoAlert()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        additionalDetailsView.profilePictureButtonView.iconImageView.image = nil
        picker.dismiss(animated: true, completion: nil)
        //picker.popViewController(animated: true)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.additionalDetailsView.profilePictureButtonView.backgroundImageView.image = image
    }
    
    func presentPhotoAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (takePhotoAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                //self.navigationController?.pushViewController(imagePicker, animated: true)
            }
        }
        
        let choosePhotoAction = UIAlertAction(title: "Choose From Library", style: .default) { (choosePhotoAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLib = UIImagePickerController()
                photoLib.delegate = self
                photoLib.sourceType = .photoLibrary
                photoLib.allowsEditing = true
                self.present(photoLib, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            //dismiss?
        }
        
        alert.addAction(takePhotoAction)
        alert.addAction(choosePhotoAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}




//MARK: UITextField Delegate
extension AdditionalDetailsViewController: UITextFieldDelegate, CheckBoxDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            additionalDetailsView.emailTMTextField.textField.becomeFirstResponder()
            offsetScrollViewFor(textfield: additionalDetailsView.emailTMTextField.textField)
        case 2:
            additionalDetailsView.genderTMTextField.textField.becomeFirstResponder()
            offsetScrollViewFor(textfield: additionalDetailsView.genderTMTextField.textField)
        default: break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.count < 1 {
            switch textField.tag {
            case 3:
                textField.text = "Male"
            case 4:
                var componenets = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                if let day = componenets.day, let month = componenets.month, let year = componenets.year {
                    textField.text = "\(month) / \(day) / \(year - 21)"
                }
            default:
                break
            }
        }
        offsetScrollViewFor(textfield: textField)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        var text = textField.text!
        if text.count > 0 {
            switch textField.tag {
            case 1, 2:
                let lastChar = text.last
                if lastChar == " " {
                    text.removeLast()
                    textField.text = text
                }
            default:
                break
            }
        }
    }
    
    func checkboxWasTapped() {
        if additionalDetailsView.validateAllFields() {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
}


// MARK: PickerViews
extension AdditionalDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   
    //Date Picker
    func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .black
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(dateChanged), for: [.valueChanged, .editingDidBegin])
        additionalDetailsView.birthdayTMTextField.textField.inputView = datePicker
        var components = DateComponents()
        components.year = -21
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        datePicker.maximumDate = maxDate
        let birthdayToolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleBirthdayDoneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        birthdayToolBar.barStyle = .blackTranslucent
        birthdayToolBar.sizeToFit()
        birthdayToolBar.setItems([spaceButton, doneButton], animated: false)
        birthdayToolBar.isUserInteractionEnabled = true
        additionalDetailsView.birthdayTMTextField.textField.inputAccessoryView = birthdayToolBar
        
    }
    
    @objc func handleBirthdayDoneButton(_ sender: UIButton) {
        additionalDetailsView.birthdayTMTextField.textField.resignFirstResponder()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            additionalDetailsView.birthdayTMTextField.textField.text = "\(month) / \(day) / \(year)"
        }
    }
    
    
    
    //Gender Picker
    func setupGenderPicker() {
        let genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = .black
        genderPicker.setValue(UIColor.white, forKeyPath: "textColor")
        additionalDetailsView.genderTMTextField.textField.inputView = genderPicker
        let genderToolBar = UIToolbar()
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(handleGenderNextButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        genderToolBar.barStyle = .blackTranslucent
        genderToolBar.sizeToFit()
        genderToolBar.setItems([spaceButton, nextButton], animated: false)
        genderToolBar.isUserInteractionEnabled = true
        additionalDetailsView.genderTMTextField.textField.inputAccessoryView = genderToolBar
    }
    
    @objc func handleGenderNextButton() {
        additionalDetailsView.birthdayTMTextField.textField.becomeFirstResponder()
        offsetScrollViewFor(textfield: additionalDetailsView.birthdayTMTextField.textField)
    }
    
    //MARK: Picker Datasource and Delegate functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = genderOptions[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20),NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        additionalDetailsView.genderTMTextField.textField.text = genderOptions[row]
    }
    
}


