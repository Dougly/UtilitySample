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
    
//    override var prefersStatusBarHidden: Bool {
//        return false
//    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
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
            return 3
        } else {
            return demoPlaces.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell") as! ClubTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell") as! PlaceTableViewCell
            cell.label.text = demoPlaces[indexPath.row]
            cell.checkImageView.isHidden = true
            cell.label.textColor = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
            if indexPath.row == selectedPlace {
                cell.label.textColor = .white
                cell.checkImageView.isHidden = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! ClubTableViewCell
            cell.clubTableViewCellView.highlightView.alpha = 0.2
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                cell.clubTableViewCellView.highlightView.alpha = 0.0
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
        UIView.animate(withDuration: 0.3) {
            let distance = self.view.frame.maxY - self.cityStateTitleView.bounds.maxY
            self.placesTableViewBottomToCityStateBottom.constant = distance
            self.view.layoutIfNeeded()
        }
        
    }
    
    func hidePlaces() {
        UIView.animate(withDuration: 0.3) {
            self.placesTableViewBottomToCityStateBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func showFilter() {
        let alert = UIAlertController(title: "Filter by:", message: nil, preferredStyle: .actionSheet)
        let locationAction = UIAlertAction(title: "Location", style: .default) { (locationAction) in
            //dismiss?
        }
        let priceAction = UIAlertAction(title: "Price", style: .default) { (priceAction) in
            //dismiss?
        }
        let distanceAction = UIAlertAction(title: "Distance", style: .default) { (distanceAction) in
            //dismiss?
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



