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
    
    let storage = FirebaseStorageFacade()
    let auth = FirebaseAuthFacade()
    let database = FirebaseDatabaseFacade()
    let dataStore = DataStore.sharedInstance
    let genderOptions = ["Not Specified", "Male", "Female", "Other"]
    var titleLabelYDistance: CGFloat = 0
    var changes: [String : String] = [:]
    var newImage: UIImage?
    weak var profileTableView: UITableView?
    weak var profileImageView: UIImageView?
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editProfileLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var editProfileTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        activityIndicator.startAnimating()
        let name = changes["name"]
        let email = changes["email"]
        let birthday = changes["birthday"]
        let gender = changes["gender"]
        let description = changes["description"]
        let venmoID = changes["venmoID"]
        
        updateImageData() { (url) in
            self.database.updateUserInfo(name, email: email, gender: gender, birthday: birthday, profileImageURL: url, venmoID: venmoID, description: description)
            
            // Update info locally so profile is updated immediatley after popping this view controller.
            if let url = url { self.dataStore.profileImage = url.absoluteString }
            if let name = name { self.dataStore.name = name }
            if let email = email { self.dataStore.email = email }
            if let birthday = birthday { self.dataStore.birthday = birthday }
            if let gender = gender { self.dataStore.gender = gender }
            if let description = description { self.dataStore.description = description }
            if let venmoID = venmoID { self.dataStore.venmoID = venmoID }
            
            self.activityIndicator.stopAnimating()
            if let newImage = self.newImage {
                self.profileImageView?.image = newImage
            }
            self.profileTableView?.reloadData()
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    func updateImageData(completion: @escaping (URL?) -> Void) {
        if let image = self.newImage {
            let data = UIImageJPEGRepresentation(image, 0.5)
            storage.uploadProfileImage(data: data!) { (metaData) in
                let url = metaData.downloadURL()
                completion(url)
            }
        } else {
            completion(nil)
        }
    }

    
    @IBAction func backButtonTapped(_ sender: UIButton) {
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
        case 6: return 90
        case 8, 9, 10: return 80
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
            cell.tableMeButton.delegate = self
            return cell
        case .textfield:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldTableViewCell") as! TextFieldTableViewCell
            cell.textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            cell.textField.tag = indexPath.row
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
    
    @objc func textFieldChanged(_ sender: UITextField) {
        print("text Field changed")
        switch sender.tag {
        case 1:
            changes["name"] = sender.text!
        case 2:
            changes["email"] = sender.text!
        case 3:
            changes["birthday"] = sender.text!
        case 4:
            changes["gender"] = sender.text!
            print("birhtday changed")
        default:
            break
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
            textfieldCell.textField.keyboardAppearance = .dark
            textfieldCell.textField.autocapitalizationType = .words
            textfieldCell.textField.autocorrectionType = .no
        case 2:
            textfieldCell.titleLabel.text = "Email"
            textfieldCell.textField.text = dataStore.email
            textfieldCell.textField.keyboardAppearance = .dark
            textfieldCell.textField.autocapitalizationType = .none
            textfieldCell.textField.keyboardType = .emailAddress
            textfieldCell.textField.autocorrectionType = .no
        case 3:
            textfieldCell.titleLabel.text = "Birthday"
            textfieldCell.textField.text = dataStore.birthday
            self.setupDatePicker(textField: textfieldCell.textField)
        case 4:
            textfieldCell.titleLabel.text = "Gender"
            textfieldCell.textField.text = dataStore.gender
            setupGenderPicker(textField: textfieldCell.textField)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 10 {
            auth.logout() { success in
                if success {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
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


extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Date Picker
    func setupDatePicker(textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .black
        datePicker.setValue(false, forKeyPath: "highlightsToday")
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(dateChanged), for: [.valueChanged, .editingDidBegin])
        textField.inputView = datePicker
        var components = DateComponents()
        components.year = -21
        let maxDate = Calendar.current.date(byAdding: components, to: Date())
        datePicker.maximumDate = maxDate
        let birthdayToolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleBirthdayDoneButton))
        doneButton.tintColor = .white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        birthdayToolBar.barStyle = .blackTranslucent
        birthdayToolBar.sizeToFit()
        birthdayToolBar.setItems([spaceButton, doneButton], animated: false)
        birthdayToolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = birthdayToolBar
        
    }
    
    @objc func handleBirthdayDoneButton(_ sender: UIButton) {
        let indexPath = IndexPath(item: 3, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell
        if let cell = cell {
            cell.textField.resignFirstResponder()
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let indexPath = IndexPath(item: 3, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell
        
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            if let cell = cell {
                let birthday = "\(month) / \(day) / \(year)"
                self.changes["birthday"] = birthday
                cell.textField.text = birthday
            }
        }
    }
    
    
    //Gender Picker
    func setupGenderPicker(textField: UITextField) {
        let genderPicker = UIPickerView()
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.backgroundColor = .black
        genderPicker.setValue(UIColor.white, forKeyPath: "textColor")
        textField.inputView = genderPicker
        let genderToolBar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleGenderDoneButton))
        doneButton.tintColor = .white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        genderToolBar.barStyle = .blackTranslucent
        genderToolBar.sizeToFit()
        genderToolBar.setItems([spaceButton, doneButton], animated: false)
        genderToolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = genderToolBar
    }
    
    @objc func handleGenderDoneButton(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(item: 4, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell
        if let cell = cell {
            cell.textField.resignFirstResponder()
        }
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
        let indexPath = IndexPath(item: 4, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell
        if let cell = cell {
            self.changes["gender"] = genderOptions[row]
            cell.textField.text = genderOptions[row]
        }
    }
}

//MARK: Camera And Photo
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TableMeButtonDelegate {
    
    func tableMeButtonActivted() {
        presentPhotoAlert()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! PictureTableViewCell
        cell.tableMeButton.backgroundImageView.image = image
        self.newImage = image
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

    
    

