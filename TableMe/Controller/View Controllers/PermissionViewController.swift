//
//  NotificationPermissionViewController.swift
//  TableMe
//
//  Created by Douglas Galante on 11/30/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

enum PermissionVCType {
    case notification, location
}

class PermissionsViewController: UIViewController, TableMeButtonDelegate, CLLocationManagerDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var permissionVCType: PermissionVCType?
    var image: UIImage?
    var note: String?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var continueButton: TableMeButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
        continueButton.delegate = self
    }
    
    func setValues() {
        titleLabel.text = self.title ?? "error"
        imageView.image = self.image ?? #imageLiteral(resourceName: "notificationGraphic")
        noteLabel.text = self.note ?? "error"
        continueButton.titleLabel.textColor = .white
        continueButton.titleLabel.text = "Continue"
        continueButton.titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
    }
    
    func buttonActivted() {
        guard let permissionVCType = self.permissionVCType else { return }
        switch permissionVCType {
        case .notification:
            let application = UIApplication.shared
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert], completionHandler: { (granted, error) in
                if error != nil {
                    print("🔥 \(error!.localizedDescription)")
                }
                DispatchQueue.main.async {
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let permissionVC = main.instantiateViewController(withIdentifier: "permissionVC") as! PermissionsViewController
                    permissionVC.permissionVCType = .location
                    permissionVC.title = "Location"
                    permissionVC.image = #imageLiteral(resourceName: "locationGrapahic")
                    permissionVC.note = "Let’s make sure you are always finding clubs that are nearest you. Allow us to access your location."
                    self.navigationController?.pushViewController(permissionVC, animated: true)
                }
            })
            
            if !application.isRegisteredForRemoteNotifications {
                application.registerForRemoteNotifications()
            }
            
        case .location:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.locationManager.delegate = self
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                appDelegate.locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways, .denied,  .restricted:
                self.navigationController?.popToRootViewController(animated: true)
                break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    deinit {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print("locationManager delgate: \(appDelegate.locationManager.delegate ?? nil)")
    }
    
    
    
}
    

