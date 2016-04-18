//
//  Action.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 16/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
///Class that models actions found in messsages
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
    /**
     Adds the objects of an action
     
     - Parameters:
     - object: an AnyObject instance that the action will use to carry out its intent. Each action subclass will the specific object types that it can operate one
     
     */
    func addObject(object: AnyObject){
    objects.append(object)
    }
}
