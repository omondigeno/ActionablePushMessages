//
//  Message.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 12/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation

/// Message class used to hold chat messages
class Message {
    
    var message: String!
    var sender: String!
    
    /**
     Initializes a new message
     
     - Parameters:
     - message: message to display
     - sender: The sender id
     
     - Returns: the initialized message.
     */
    init(message: String, sender: String) {
        self.message = message
        self.sender = sender
    }
}