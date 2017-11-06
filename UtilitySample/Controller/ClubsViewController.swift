//
//  ClubsViewController.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ClubsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let demoPlaces = ["Boston, MA", "Chicago, IL", "Las Vegas, NV", "Los Angeles, CA", "Miami, FL", "Orlando, FL", "San Francisco, CA"]
    
    var demoData =
        [["name" : "Cove Loung", "tables" : 3, "cost" : "$$$", "activities" : ["Drinks", "Food", "Music"], "address" : "305 Willows Roaders Longname, FL 33132", "distance" : 0.5, "image" : #imageLiteral(resourceName: "samplePhoto1")],
         ["name" : "Purdy Loung", "tables" : 2, "cost" : "$$", "activities" : ["Drinks", "Food", "Music"], "address" : "34 NE 11th St,  Miami, FL 33132", "distance" : 0.2, "image" : #imageLiteral(resourceName: "samplePhoto2")],
         ["name" : "Fake Place", "tables" : 5, "cost" : "$$$$", "activities" : ["Drinks", "Food"], "address" : "555 NE 7th ave, New York, NY 10009", "distance" : 0.2, "image" : #imageLiteral(resourceName: "samplePhoto3")],
         ["name" : "The Spot", "tables" : 0, "cost" : "$$", "activities" : ["Drinks", "Food", "Karaoke"], "address" : "345 Berkely, Anywhere, NY 10009", "distance" : 1.5, "image" : #imageLiteral(resourceName: "samplePhoto4")]
    ]
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var selectedPlace = 4
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placesTableViewBottomToCityStateBottom: NSLayoutConstraint!
    @IBOutlet weak var cityStateTitleView: CityStateTitleView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ClubTableViewCell.self, forCellReuseIdentifier: "clubCell")
        tableView.dataSource = self
        tableView.delegate = self
        cityStateTitleView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return demoData.count
        } else {
            return demoPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell") as! ClubTableViewCell
            let demoDict = demoData[indexPath.row]
            let tables = demoDict["tables"] as! Int
            let distance = demoDict["distance"] as! Double
            let name = demoDict["name"] as! String
            let cost = demoDict["cost"] as! String
            let activities = demoDict["activities"] as! [String]
            let address = demoDict["address"] as! String
            let image = demoDict["image"] as! UIImage
            cell.clubTableViewCellView.updateLabelsAndImage(tables: String(tables), distance: String(distance), name: name, cost: cost, activities: activities, address: address, image: image)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlaceTableViewCell
            cell.label.text = demoPlaces[indexPath.row]
            cell.checkImageView.isHidden = true
            cell.label.alpha = 0.4
            if indexPath.row == selectedPlace {
                cell.label.alpha = 1.0
                cell.checkImageView.isHidden = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! ClubTableViewCell
            cell.clubTableViewCellView.contentView.alpha = 0.5
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                cell.clubTableViewCellView.contentView.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
            self.selectedPlace = indexPath.row
            tableView.reloadData()
            cityStateTitleView.cityStateLabel.text = cell.label.text ?? "error"
            hidePlaces()
            cityStateTitleView.changeViews()
        }
    }

}

extension ClubsViewController: PlaceUIDelegate {
    
    func revealPlaces() {
        self.tabBarController?.tabBar.isHidden = true
        UIView.animate(withDuration: 0.3) {
            let distance = self.view.frame.maxY - self.cityStateTitleView.bounds.maxY
            self.placesTableViewBottomToCityStateBottom.constant = distance
            self.view.layoutIfNeeded()
        }
        
    }
    
    func hidePlaces() {
        self.tabBarController?.tabBar.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.placesTableViewBottomToCityStateBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func showFilter() {
        let alert = UIAlertController(title: "Filter by:", message: nil, preferredStyle: .actionSheet)
        
        let locationAction = UIAlertAction(title: "Location", style: .default) { (locationAction) in
            self.demoData.sort(by: { (place1, place2) -> Bool in
                let place1Address = place1["address"] as! String
                let place2Address = place2["address"] as! String
                return place1Address < place2Address
            })
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            self.tableView.reloadData()
        }
        
        let priceAction = UIAlertAction(title: "Price", style: .default) { (priceAction) in
            self.demoData.sort(by: { (place1, place2) -> Bool in
                let place1Price = place1["cost"] as! String
                let place2Price = place2["cost"] as! String
                return place1Price.count < place2Price.count
            })
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            self.tableView.reloadData()
        }
        
        let distanceAction = UIAlertAction(title: "Distance", style: .default) { (distanceAction) in
            self.demoData.sort(by: { (place1, place2) -> Bool in
                let place1Distance = place1["distance"] as! Double
                let place2Distance = place2["distance"] as! Double
                return place1Distance < place2Distance
            })
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            //dismiss?
        }
        
        alert.addAction(locationAction)
        alert.addAction(priceAction)
        alert.addAction(distanceAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}



