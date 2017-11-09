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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costAndActivitesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        setupView()
        applyGradient()
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
            addressLabel.text = cellView.addressLabel.text
            distanceLabel.text = cellView.distanceLabel.text
        }
    }
    
    func applyGradient() {
        let startingColorOfGradient = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor
        let endingColorOFGradient = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = imageView.bounds
        gradient.bounds = imageView.bounds
        gradient.colors = [startingColorOfGradient , endingColorOFGradient]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.imageView.layer.insertSublayer(gradient, at: 0)
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
        return cell
    }
    
}
