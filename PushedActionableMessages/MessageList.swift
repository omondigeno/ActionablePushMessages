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
        self.registerClass(MessageViewLeft.self, forCellReuseIdentifier: "cellLeft")
        self.registerClass(MessageViewRight.self, forCellReuseIdentifier: "cellRight")
        self.registerClass(MessageViewLeftAction.self, forCellReuseIdentifier: "cellLeftAction")
        self.backgroundColor = UIColor.clearColor()
        self.separatorColor = UIColor.clearColor()

        superView.addSubview(self)
        
        ///Set autolayout constraints
        self.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(superView)
            make.width.equalTo(Common.dimensionWidth())
            make.top.equalTo(90)
            ///place list just above chat textview
            make.bottom.equalTo(-70)
        }
        
        rowHeight = UITableViewAutomaticDimension
        
    }
       
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row

        var cell: MessageView?
        

        /// Set layout parameters, background color, margin depending on sender
        if list[row].sender == Utils.getUUID(){
            ///Get a reusable instance of a view we will use to render messages sent by this device's user
            cell = tableView.dequeueReusableCellWithIdentifier("cellRight", forIndexPath: indexPath) as! MessageViewRight
        }else{
            
            if list[row].action == nil {
                ///Get a reusable instance of a view we will use to render messages with no actions sent by another user
                cell = tableView.dequeueReusableCellWithIdentifier("cellLeft", forIndexPath: indexPath) as! MessageViewLeft
            }
            if let action = list[row].action {
                ///Get a reusable instance of a view we will use to render messages with actions sent by another user
                cell = tableView.dequeueReusableCellWithIdentifier("cellLeftAction", forIndexPath: indexPath) as! MessageViewLeftAction
                
                ///Set action button title
            (cell as! MessageViewLeftAction).setActionButtonTitle(action.type.wordCaps)
            }


        }
        
        
        
        cell?.messageLabel.text = list[row].message
        
        cell?.textLabel?.numberOfLines = 0 ///makes sure size will be adjusted to wrap content
        cell?.textLabel?.lineBreakMode = .ByWordWrapping
        cell?.textLabel?.hidden = true
        
        //# TODO: find a solution that does not require setting text twice
        cell?.textLabel?.text = list[row].message ///this text is not visible but helps us calculate height required to display our message
        cell?.textLabel?.font = UIFont.systemFontOfSize(18);
        cell?.textLabel?.textColor = MaterialColor.white
        
        ///Make textLabel have same width as the visible messageLabel so that we have the correct height calculated
        cell?.textLabel?.snp_updateConstraints { (make) -> Void in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(Common.dimensionWidth()-30)
        }
        
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let row = indexPath.row
        
        //TODO: Support wrapping of content for messages with actions too
        if list[row].action != nil {
        return 120
        }
        ///makes sure size will be adjusted to wrap content
     return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        ///makes sure size will be adjusted to wrap content
        return UITableViewAutomaticDimension
    }
    
    ///Hack to allow messages to be aligned to bottom. No iOS API for this
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectZero)
        headerView.userInteractionEnabled = false;
        
        return headerView
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        ///Hack to allow messages to be aligned to bottom. No iOS API for this
        return tableView.frame.size.height
    }
    
    ///Creating a footer enables correct scrolling to bottom when new messages are added
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectZero)
        footerView.userInteractionEnabled = false;
        
        return footerView
        
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        ///Creating a footer enables correct scrolling to bottom when new messages are added
        return 100
    }
    
    func addMessage(message: Message) {
        list.append(message)
        
        ///Refresh list
        reloadData()
        
        /// scroll to bottom to the latest message. It is a sync to allow table to finish reloading

        ///Delay in nanoseconds
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        ///scroll in UI thread
        dispatch_after(time, dispatch_get_main_queue(), {

            let indexPath = NSIndexPath(forRow: self.list.count - 1, inSection: 0)
        self.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
            
        })
        
        
        
    
    }
}