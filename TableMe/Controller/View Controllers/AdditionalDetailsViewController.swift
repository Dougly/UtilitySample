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
    
    let genderOptions = ["Male", "Female", "Other"]
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionalDetailsView: EditProfileView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        setupDatePicker()
        setupGenderPicker()
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
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollViewBottomConstraint.constant = keyboardHeight * -1
        }
    }
    
    @objc func keyboardWillDisappear() {
        scrollViewBottomConstraint.constant = 0
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
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        additionalDetailsView.birthdayTextField.inputView = datePicker
        
        let birthdayToolBar = UIToolbar()
        birthdayToolBar.barStyle = .blackTranslucent
        birthdayToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleBirthdayDoneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        birthdayToolBar.setItems([spaceButton, doneButton], animated: false)
        birthdayToolBar.isUserInteractionEnabled = true
        additionalDetailsView.birthdayTextField.inputAccessoryView = birthdayToolBar
    }
    
    @objc func handleBirthdayDoneButton(_ sender: UIButton) {
        additionalDetailsView.birthdayTextField.resignFirstResponder()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            additionalDetailsView.birthdayTextField.text = "\(month) / \(day) / \(year)"
        }
    }
    
    //Gender Picker
    func setupGenderPicker() {
        let genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = .black
        genderPicker.setValue(UIColor.white, forKeyPath: "textColor")
        additionalDetailsView.genderTextField.inputView = genderPicker
        
        let genderToolBar = UIToolbar()
        genderToolBar.barStyle = .blackTranslucent
        genderToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleGenderDoneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        //let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButton))
        genderToolBar.setItems([spaceButton, doneButton], animated: false)
        genderToolBar.isUserInteractionEnabled = true
        additionalDetailsView.genderTextField.inputAccessoryView = genderToolBar
        
    }
    
    @objc func handleGenderDoneButton() {
        additionalDetailsView.genderTextField.resignFirstResponder()
        additionalDetailsView.birthdayTextField.becomeFirstResponder()
    }
    
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
        additionalDetailsView.genderTextField.text = genderOptions[row]
    }
    
    
}
