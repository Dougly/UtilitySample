//
//  StringExtension.swift
//  TableMe
//
//  Created by Douglas Galante on 11/30/17.
//  Copyright © 2017 Dougly. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
    }
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) { return self }
        return String( Array(self).prefix(upTo: n) )
    }
}
