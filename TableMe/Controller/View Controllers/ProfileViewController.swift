//
//  ProfileViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 12/4/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, TableMeButtonDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let database = FirebaseDatabaseFacade()
    let auth = FirebaseAuthFacade()
    var userInfo: [String : Any]?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: TableMeButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var venmoIDLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Replace with safer code after layout is finished
        let user = auth.getCurrentUser()
        if let user = user {
            if let phoneNumber = user.phoneNumber {
                database.readValueOnce(at: "users/\(phoneNumber)") { (userInfo) in
                    self.userInfo = userInfo
                    if let url = URL(string: userInfo!["profileImage"] as! String) {
                        self.profileImageView.kf.setImage(with: url)
                    }
                }
            }
        }
        
        scrollView.delegate = self
        //scrollView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //profileImageView.layer.cornerRadius = 100
        profileImageView.clipsToBounds = true
        
        editProfileButton.setProperties(title: nil, icon: #imageLiteral(resourceName: "edit"), backgroundImage: nil, backgroundColor: .themePurple, cornerRadius: 25)
        editProfileButton.delegate = self
        
        self.descriptionLabel.text = "Need something long as a placeholder so the profile view looks a little better. Also scrolling up could potentially be a problem here because the back arrow will overlap with text. Blah Blah Blah."

    }
    
    func buttonActivted() {
        //present editVC
        let profileSB = UIStoryboard(name: "Profile", bundle: nil)
        let editProfileVC = profileSB.instantiateViewController(withIdentifier: "editProfileVC")
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableCell", for: indexPath) as! TableCollectionViewCell
        cell.tableCellView.titleLabel.text = "HELLO"
        cell.tableCellView.imageView.image = #imageLiteral(resourceName: "samplePhoto4")
        cell.tableCellView.dateLabel.text = "4 / 11 / 88"
        cell.tableCellView.placeLabel.text = "Cove Lounge"
        cell.tableCellView.seatsFilledLabel.text = "8/10 seats filled"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 271, height: 201)
    }
    
}

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        let offset = scrollView.contentOffset
        let imageHeightBase: CGFloat = 200
        //let cornerRadiusBase: CGFloat = 100
        if offset.y < 0 {
            self.profileImageHeightConstraint.constant = imageHeightBase - offset.y
            //self.profileImageView.layer.cornerRadius = cornerRadiusBase - (offset.y / 2)
        }
    }
    
}
