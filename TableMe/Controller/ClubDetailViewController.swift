//
//  ClubDetailViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/9/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ClubDetailViewController: UIViewController {
    
    let demoData = [
        ["name" : "Girls Night Out", "time" : "Tomorrow, 10:00pm", "seats" : "1", "image" :  #imageLiteral(resourceName: "samplePhoto5")],
        ["name" : "Winter Jam Party", "time" : "Tomorrow, 11:00pm", "seats" : "3", "image" :  #imageLiteral(resourceName: "samplePhoto6")],
        ["name" : "Monday Night Football Party", "time" : "January 10th, 10:00pm", "seats" : "6", "image" :  #imageLiteral(resourceName: "samplePhoto7")],
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var selectedCell: ClubTableViewCell?
    var startingYPosition: CGFloat = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costAndActivitesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
        applyGradient()
        addGesture()
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismissDetail()
    }
    
    func setNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func setupView() {
        addButton.layer.cornerRadius = 20
        addButton.clipsToBounds = true
        
        if let selectedCell = selectedCell {
            let cellView = selectedCell.clubTableViewCellView
            imageView.image = cellView.imageView.image
            nameLabel.text = cellView.nameLabel.text
            costAndActivitesLabel.text = cellView.costAndActivitiesLabel.text
            
            if let splitAddress = cellView.addressLabel.text?.components(separatedBy: ",") {
                let address = splitAddress[0] + ","
                let cityStatZip = splitAddress[1].trimmingCharacters(in: .whitespacesAndNewlines) + "," + splitAddress[2]
                cityLabel.text = cityStatZip
                addressLabel.text = address
            }
            
            distanceLabel.text = cellView.distanceLabel.text
        }
    }
    
    func applyGradient() {
        let startingColorOfGradient = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor
        let endingColorOFGradient = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.bounds = gradientView.bounds
        gradient.colors = [startingColorOfGradient , endingColorOFGradient]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(scaleImage))
        self.gradientView.addGestureRecognizer(panGesture)
    }
    
    @objc func scaleImage(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.imageView)
        if gestureRecognizer.state == .began {
            startingYPosition = gestureRecognizer.translation(in: self.imageView).y
        }
        if gestureRecognizer.state == .changed {
            if translation.y > startingYPosition {
                imageViewWidthConstraint.constant = translation.y - startingYPosition
            }
        }
        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: [.curveEaseInOut], animations: {
                self.imageViewWidthConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (success) in
                self.startingYPosition = 0
            })
        }
        
    }
    
}

extension ClubDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "availableTableCell") as! AvailableTableCell
        let data = demoData[indexPath.row]
        let image = data["image"] as! UIImage
        let name = data["name"] as! String
        let time = data["time"] as! String
        let seats = data["seats"] as! String
        cell.cellImageView.image = image
        cell.nameLabel.text = name
        cell.timeLabel.text = time
        cell.numSeatsLabel.text = seats
        cell.cellImageView.layer.cornerRadius = 20
        cell.cellImageView.clipsToBounds = true
        
        if indexPath.row == demoData.count - 1 {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0);
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AvailableTableCell
        cell.contentView.alpha = 0.5
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            cell.contentView.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { success in
//            let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ClubDetailVC") as! ClubDetailViewController
//            destVC.selectedCell = cell
//            self.presentDetail(destVC)
        })
    }
    
}