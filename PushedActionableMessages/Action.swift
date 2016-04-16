//
//  Action.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 16/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
class Action {
    
    var type: String!
    var objects: [AnyObject]!
    
    /**
     Initializes a new action
     
     - Parameters:
     - type: indicates type of action. It tells us what to do, which controls to display
     
     - Returns: the initialized action.
     */
    init(type: String) {
        self.type = type
        self.objects = [AnyObject]()
    }
    
    func addObject(object: AnyObject){
    objects.append(object)
    }
}

let payAction = "PAY_ACTION"
