//
//  DataStore.swift
//  TableMe
//
//  Created by Douglas Galante on 12/5/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import Foundation

class DataStore {
    
    static let sharedInstance = DataStore()
    private init() {}
    var userInfo: [String : Any] = [:]
    var name = ""
    var email = ""
    var gender = ""
    var birthday = ""
    var profileImage = ""
    var phoneNumber = ""
    var description = ""
    var venmoID = ""
}
