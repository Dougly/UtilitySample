//
//  ClubsViewController.swift
//  UtilitySample
//
//  Created by Douglas Galante on 11/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit

class ClubsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ClubTableViewCell.self, forCellReuseIdentifier: "clubCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clubCell") as! ClubTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ClubTableViewCell
        cell.clubTableViewCellView.highlightView.alpha = 0.11
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            cell.clubTableViewCellView.highlightView.alpha = 0.0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    

}
