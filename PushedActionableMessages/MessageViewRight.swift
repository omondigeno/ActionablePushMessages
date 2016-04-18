//
//  MessageViewRight.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 18/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import MK

///A reusable view used to display messages to the right of the message list
class MessageViewRight: MessageView {
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(0)
            ///align to right
            make.left.equalTo(20)
            ///add 20 points to calculated height to avoid undisplayed text
            make.height.equalTo(textLabel!.snp_height).offset(20)
            make.width.equalTo(Common.dimensionWidth()-30)
        }
        messageLabel.layer.backgroundColor = MaterialColor.blue.accent3.CGColor
        
        triangleView.bgColor = UIColor.brandColor.CGColor
        triangleView.snp_updateConstraints { (make) -> Void in
            ///align to right
            make.right.equalTo(0)
            make.top.equalTo(messageLabel.snp_top).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
   
}