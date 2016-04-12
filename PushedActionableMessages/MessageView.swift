//
//  MessageView.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 12/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import MK

class MessageView: UITableViewCell {
    
    var messageLabel = MessageLabel(frame: CGRectZero)
   
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(messageLabel)
        
        let bgColorView = UIView(frame: CGRectZero)
        bgColorView.backgroundColor = UIColor.clearColor()
        selectedBackgroundView = bgColorView
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
}