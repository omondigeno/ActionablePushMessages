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

///A reusable view used to display table row content
class MessageView: UITableViewCell {
    
    /// initialize message label with rect = 0 because autolayout will take care of setting height to wrap contents
    var messageLabel = MessageLabel(frame: CGRectZero)
    ///Used to create caption image for chat messages
    var triangleView = TriangeView(frame: CGRectMake(0, 0 , 30, 20))

   
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(triangleView)
        
        self.addSubview(messageLabel)
        
        triangleView.translatesAutoresizingMaskIntoConstraints = false
       messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ///Remove ability to show selected row for now
        selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
}