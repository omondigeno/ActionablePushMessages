//
//  ViewController.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import UIKit
import MK
import SnapKit
import ObjectMapper

class ViewController: UIViewController {
    
    var messageList: MessageList?
    let chatTextView = UITextView(frame: CGRectZero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Called when view has been loaded
        /// We initialize and add views here
view.backgroundColor = UIColor.whiteColor()
        let dividerView = UIView(frame:  CGRectZero)
        dividerView.backgroundColor = UIColor.brandColor
        
        view.addSubview(dividerView)
        ///Set autolayout constraints
        dividerView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(5)
            make.top.equalTo(80)
 }
        /// add logo
        let imageView = UIImageView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = UIImage(named: "logo")
        view.addSubview(imageView)
        ///Set autolayout constraints
        imageView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            make.width.equalTo(138)
            make.height.equalTo(60)
            make.top.equalTo(10)
 }
        
         messageList = MessageList(superView: view)
        
        /// initialize chat textview properties
        chatTextView.layer.cornerRadius = 5
        chatTextView.layer.borderWidth = 2
        chatTextView.layer.borderColor = UIColor.brandColor.CGColor
        chatTextView.font = UIFont.systemFontOfSize(20);
        
    
        view.addSubview(chatTextView)
        ///Set autolayout constraints
  chatTextView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(5)
            make.height.equalTo(60)
            make.bottom.equalTo(-5)
            make.right.equalTo(-70)

        }
        
        //// Create send button, set its properties and add it to main view
        let sendButton = RaisedButton(frame: CGRectZero)
        sendButton.addTarget(self, action: "send:", forControlEvents: .TouchUpInside)
        sendButton.pulseScale = true
        sendButton.pulseFill = true
        sendButton.pulseColor = MaterialColor.white
        sendButton.cornerRadius = .Radius2
        sendButton.backgroundColor = UIColor.brandColor
        sendButton.setImage(UIImage(named: "ic_arrow_forward"), forState: .Normal)
        view.addSubview(sendButton)
        ///Set autolayout constraints
        sendButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.bottom.equalTo(-5)
            make.right.equalTo(-5)
            
        }
      
        
    }
    /**
     Tap action handler for send button
     
     - Parameters:
     - sender: button from which action originated
     
     */
    func send(sender:UIButton){
        if chatTextView.text.characters.count > 0 {
            let message =  Message(message:chatTextView.text, sender: Utils.getUUID())
            
            if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate,
            messageString = Mapper().toJSONString(message, prettyPrint: true){
                //# TODO: handle not sent error
                if appDelegate.mqttClient.connected {
                    messageList?.addMessage(message)
                    chatTextView.text = ""
                appDelegate.mqttClient.sendMessage(messageString)
                }else{
                Common.showMessage(Utils.getString("network_error_msg"), viewController: self)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

