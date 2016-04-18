//
//  MQTTClient.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 15/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation
import CocoaMQTT
import ObjectMapper

class MQTTClient: CocoaMQTTDelegate {
    
    var mqtt: CocoaMQTT
    var connected = false;
    var timer: NSTimer?
    
    init() {
        let clientIdPid = Utils.getUUID()
        mqtt = CocoaMQTT(clientId: clientIdPid, host: "m21.cloudmqtt.com", port: 18791)
    }
    
    func connect(){
        mqtt.username = "wxvpeukp"
        mqtt.password = "YVpeswJQG0mi"
        mqtt.keepAlive = 90
        mqtt.delegate = self
        if !mqtt.connect() {
            /*timer = NSTimer.scheduledTimerWithTimeInterval(1*60*5, target:self, selector: Selector("retryConnecting"), userInfo: nil, repeats: false)*/
        }
    }
    
    dynamic func retryConnecting(){
        if !mqtt.connect() {
            /*  timer = NSTimer.scheduledTimerWithTimeInterval(1*60*5, target:self, selector: Selector("retryConnecting"), userInfo: nil, repeats: false)*/
        }/*else{
        timer?.invalidate()
        }*/
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect")
        mqtt.subscribe("chat/room/sendy/topic/payment", qos: CocoaMQTTQOS.QOS1)
        connected = true
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print(message.string)
        print(message.topic)
        
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, rootViewController = appDelegate.window?.rootViewController as? ViewController, messageObject = Mapper<Message>().map(message.string)  {

            
            if messageObject.sender != Utils.getUUID() {
                messageObject.action = NLP.extractAction(messageObject.message)
            rootViewController.messageList?.addMessage(messageObject)
            }
        }
       /* if let messageString = message.string {
            if let dataFromString = messageString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json = JSON(data: dataFromString)
                if json["d"]["OutOfZone"].boolValue{
                    if addOutOfZone{
                        addNotification(getID(message.topic))
                        addOutOfZone = false
                    }
                }else{
                    addOutOfZone = true
                }
            }
        }*/
        
    }
    
    func mqtt(mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic")
    }
    
    func mqtt(mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    func mqttDidPing(mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        print("didDisconnect")
        //retryConnecting()
        timer = NSTimer.scheduledTimerWithTimeInterval(1*60*2, target:self, selector: Selector("retryConnecting"), userInfo: nil, repeats: false)
        connected = false
    }
    
    func sendMessage(message: String){
        mqtt.publish("chat/room/sendy/topic/payment", withString: message, qos: .QOS1)
    }
    
    func getID(topic: String) -> String{
        let topicArr = topic.componentsSeparatedByString("/")
        return topicArr[4]
    }
    
   /* func addNotification(id: String){
        var notifications = [String: [String: String]]()
        if let notificationsString = Data.getData("notifications") {
            if let dataFromString = notificationsString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                var json = JSON(data: dataFromString)
                notifications = json.dictionaryObject as! [String: [String: String]]
            }
        }
        notifications[id+NSDate().LocalDateToString()] = ["title":"Out of Zone", "by":id, "image":"OutOfZone", "read":"0"]
        
        Data.saveData("notifications", value: JSON(notifications).rawString()!)
        
        if let window = UIApplication.sharedApplication().delegate?.window {
            if let tab = window!.rootViewController as? UITabBarController {
                print("reloadData******************\(tab.viewControllers?[2])")
                if let navigationViewController = tab.viewControllers?[2] as? UINavigationController {
                    if let notificationsViewController = navigationViewController.viewControllers[0] as? NotificationsViewController {
                        dispatch_async(dispatch_get_main_queue(), {
                            notificationsViewController.loadNotifications()
                            notificationsViewController.tableView?.reloadData()
                        })
                    }
                }
                var count: Int = 0
                for (_, notification): (String, [String: String]) in notifications {
                    if notification["read"]! == "0" {
                        count++
                    }
                }
                if let items = tab.tabBar.items {
                    items[2].badgeValue = String(count)
                }
            }
        }
    }*/
    deinit {
        timer?.invalidate()
    }
    
}