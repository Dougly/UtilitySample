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
   
    let headerViewHeight: CGFloat = 250
    let auth = FirebaseAuthFacade()
    let dataStore = DataStore.sharedInstance
    var headerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: TableMeButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientView: UIView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupEditProfileButton()
    }
    
    func tableMeButtonActivted() {
        let profileSB = UIStoryboard(name: "Profile", bundle: nil)
        let editProfileVC = profileSB.instantiateViewController(withIdentifier: "editProfileVC")
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupTableView() {
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
        addGradient()
    }
    
    func setupEditProfileButton() {
        editProfileButton.setProperties(title: nil, icon: #imageLiteral(resourceName: "edit"), backgroundImage: nil, backgroundColor: .themePurple, cornerRadius: 25)
        editProfileButton.delegate = self
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 60
        case 1: return 50
        case 2:
            tableView.estimatedRowHeight = 44
            return UITableViewAutomaticDimension
        case 3: return 275
        default: return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameAndVenmoCell") as! NameAndVenmoTableViewCell
            cell.nameLabel.text = dataStore.name
            cell.venmoIDLabel.text = "VenmoID - \(dataStore.venmoID)"
            return cell
        case 1:
             let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionTitle")
             return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionLabelTableViewCell") as! DescriptionLabelTableViewCell
            cell.label.text = "Placeholder text placeholder text placeholder text placeholder text placeholder text placeholder text placeholder text placeholder text placeholder text placeholder text placeholder tex"
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tablesTableViewCell") as! TablesTableViewCell
            cell.collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -headerViewHeight, width: tableView.bounds.width, height: headerViewHeight)
        if tableView.contentOffset.y < -headerViewHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    func addGradient() {
        let startingColorOfGradient = UIColor.black.cgColor
        let endingColorOFGradient = UIColor.clear.cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.bounds = gradientView.bounds
        gradient.colors = [endingColorOFGradient, startingColorOfGradient]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
}
