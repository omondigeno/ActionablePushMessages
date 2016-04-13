//
//  MessageList.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 12/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import UIKit
import MK
import SnapKit

/// A list used to display messages
class MessageList: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var list: [Message] = []
    
    /**
     Initializes a message list
     
     - Parameters:
     - superView: the container view for the message list
     
     */
    convenience init(superView: UIView) {
        self.init(frame: CGRect.zero)
        self.delegate      =   self
        self.dataSource    =   self
        /// Set the class we will use to display each table row
        self.registerClass(MessageView.self, forCellReuseIdentifier: "cell")
        self.backgroundColor = UIColor.clearColor()
        self.separatorColor = UIColor.clearColor()

        superView.addSubview(self)
        
        ///Set autolayout constraints
        self.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(superView)
            make.width.equalTo(Common.dimensionWidth())
            make.height.equalTo(self.contentSize.height+40)
            ///place list just above chat textview
            make.bottom.equalTo(-70)
        }
        
    }
       
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        ///Here we get a reusable instance of a view we will use to render our messages
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MessageView
        
        let row = indexPath.row
        
        cell.messageLabel.text = list[row].message
       
        cell.textLabel?.numberOfLines = 0 ///makes sure size will be adjusted to wrap content
        //# TODO: find a solution that does not require setting text twice
        cell.textLabel?.text = list[row].message ///this text is not visible but helps us calculate height required to display our message
        cell.textLabel?.font = UIFont.systemFontOfSize(20);
        cell.textLabel?.textColor = MaterialColor.white

        /// Set backgroun color and margin depending on sender
        if list[row].sender == Utils.getUUID(){
            cell.messageLabel.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(30)
                make.height.equalTo(cell.textLabel!)
                make.width.equalTo(Common.dimensionWidth()-30)
            }
             cell.messageLabel.layer.backgroundColor = MaterialColor.blue.accent3.CGColor
        }else{
            cell.messageLabel.snp_makeConstraints { (make) -> Void in
                make.left.equalTo(0)
                make.height.equalTo(cell.textLabel!)
 make.width.equalTo(Common.dimensionWidth()-30)
            }
            cell.messageLabel.layer.backgroundColor = MaterialColor.grey.darken3.CGColor
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        ///makes sure size will be adjusted to wrap content
     return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        ///makes sure size will be adjusted to wrap content
        return UITableViewAutomaticDimension
    }
    func addMessage(message: Message) {
        list.append(message)
        
        ///Refresh list
        reloadData()
        
        /// update layout constraints to accomodate added message
        self.snp_updateConstraints { (make) -> Void in
            make.centerX.equalTo(superview!)
             make.height.equalTo(self.contentSize.height+40)
        }
    }
}