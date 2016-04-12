//
//  Message.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 12/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation

class Message {
    
    var message: String!
    var sender: String!
    
    init(message: String, sender: String) {
        self.message = message
        self.sender = sender
    }
}