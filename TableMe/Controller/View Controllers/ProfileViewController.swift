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
    
    var headerView: UIView!
    let headerViewHeight: CGFloat = 200

    
    let database = FirebaseDatabaseFacade()
    let auth = FirebaseAuthFacade()
    let dataStore = DataStore.sharedInstance
    var userInfo: [String : Any]?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: TableMeButton!
    //@IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var venmoIDLabel: UILabel!
    //@IBOutlet weak var descriptionLabel: UILabel!
    //@IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var profileImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.contentInset = UIEdgeInsets(top: headerViewHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -headerViewHeight)
        updateHeaderView()
        
        let url = URL(string: dataStore.profileImage)
        self.profileImageView.kf.setImage(with: url)
        
        
        
        
        
        //scrollView.delegate = self
        //scrollView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        //collectionView.delegate = self
        //collectionView.dataSource = self
        
        //profileImageView.layer.cornerRadius = 100
        
        editProfileButton.setProperties(title: nil, icon: #imageLiteral(resourceName: "edit"), backgroundImage: nil, backgroundColor: .themePurple, cornerRadius: 25)
        editProfileButton.delegate = self
     

    }
    
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -headerViewHeight, width: tableView.bounds.width, height: headerViewHeight)
        if tableView.contentOffset.y < -headerViewHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
            
        }
        headerView.frame = headerRect
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameAndVenmoCell") as! NameAndVenmoTableViewCell
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("hi")
        updateHeaderView()
//        let offset = scrollView.contentOffset
//        //let cornerRadiusBase: CGFloat = 100
//        if offset.y < 0 {
//            self.profileImageHeightConstraint.constant = imageHeightBase - offset.y
//            //self.profileImageView.layer.cornerRadius = cornerRadiusBase - (offset.y / 2)
//        }
    }
    
}
