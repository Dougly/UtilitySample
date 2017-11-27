//
//  PresentPickerDelegate.swift
//  TableMe
//
//  Created by Douglas Galante on 11/27/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import Foundation

protocol PresentPickerDelegate {
    func presentPicker(type: PickerType)
}

enum PickerType {
    case date, gender
}
