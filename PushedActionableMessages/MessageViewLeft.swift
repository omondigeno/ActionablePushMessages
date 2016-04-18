//
//  MessageViewLeft.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 18/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import MK

///A reusable view used to display table row content
class MessageViewLeft: MessageView {
    
    /// initialize message label with rect = 0 because autolayout will take care of setting height to wrap contents
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        messageLabel.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(10)
            make.height.equalTo(textLabel!.snp_height).offset(20)
            // make.top.equalTo(0)
            make.width.equalTo(Common.dimensionWidth()-30)
        }
        messageLabel.layer.backgroundColor = MaterialColor.grey.darken1.CGColor
        
        triangleView.bgColor = MaterialColor.grey.darken1.CGColor
        triangleView.snp_updateConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.top.equalTo(messageLabel.snp_top).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(30)
        }
        
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
}