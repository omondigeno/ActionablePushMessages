//
//  Utils.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
class Utils {
    
    class func getString (name: String) -> String {
        return NSLocalizedString(name, comment: "")
    }
    
    class func saveData(name: String, value: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(value, forKey: name)
    }
    
    class func getData(name: String) -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.valueForKey(name) as? String
    }
    
    class func getUUID() -> String? {
        if let UUID = getData("UUID") {
        return UUID
        }
        else {
            let UUID = NSUUID().UUIDString
            saveData("UUID", value: UUID)
            return UUID
        }
    }
}