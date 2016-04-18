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

/// MQTTClient handles MQTT connections, subscriptions, and publishing
class MQTTClient: CocoaMQTTDelegate {
    
    var mqtt: CocoaMQTT
    var connected = false;
    ///used to retry connecting
    var timer: NSTimer?
    
    /**
     Initializes a new MQTTClient
     
     - Returns: the initialized MQTTClient.
     */
    init() {
        ///     Current host is CloudMQTT but can be hosted on premise using RabbitMQ for message queueing
        mqtt = CocoaMQTT(clientId: Utils.getUUID(), host: "m21.cloudmqtt.com", port: 18791)
    }
    
    /**
     Sets connection parameters and tries to connect.
     */
    func connect(){
        ///In production we will use user's credentials to connect instead of having connection credentials
        mqtt.username = "wxvpeukp"
        mqtt.password = "YVpeswJQG0mi"
        /// Longest period of time during which connection can remain idle
        mqtt.keepAlive = 90
        mqtt.delegate = self
        
        ///if  connections fails the function mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) is called
        mqtt.connect()
        

    }
    
    /**
     Called by the timer after every 2 minutes to retry connectiong.
     */
    dynamic func retryConnecting(){
        mqtt.connect()
    }
    /**
     CocoaMQTTDelegate callback when client connected successfully.
     
     On successful connection we subscribe to a topic, indicating the quality of service required.
     In this case it is level 1, meaning it is guaranteed that a message will be delivered at least once to the receiver
     */
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("didConnect")
        mqtt.subscribe(chatTopic, qos: CocoaMQTTQOS.QOS1)
        connected = true
    }
    
    /**
     CocoaMQTTDelegate callback to acknowledge client connection.
     */
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        
    }
    
    /**
     CocoaMQTTDelegate callback to inform about successful publishing of a message.
     */
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    /**
     A CocoaMQTTDelegate callback that s called when a message is received.
     */
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print(message.string)
        print(message.topic)
        
        ///Ensure the view is loaded and that we can map the message string into a message object before displaying message
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, rootViewController = appDelegate.window?.rootViewController as? ViewController, messageObject = Mapper<Message>().map(message.string)  {

            ///Avoid handling messages sent by self. In future subscribe to different topics
            if messageObject.sender != Utils.getUUID() {
                
                ///Extract action using natural language processing
                messageObject.action = NLP.extractAction(messageObject.message)
                
                ///add message object to list
            rootViewController.messageList?.addMessage(messageObject)
            }
        }
        
    }
    
    /**
     CocoaMQTTDelegate callback called upon succesful client subscription.
     */
    func mqtt(mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic")
    }
    
    /**
     CocoaMQTTDelegate callback called when client unsubscribes.
     */
    func mqtt(mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    /**
     CocoaMQTTDelegate callback called to indicate client sent a request to determine if broker is still alive.
     */
    func mqttDidPing(mqtt: CocoaMQTT) {
        
    }
    
    /**
     CocoaMQTTDelegate callback called to indicate client received a request to determine if client is still alive.
     */
    func mqttDidReceivePong(mqtt: CocoaMQTT) {
        
    }
    
    /**
     CocoaMQTTDelegate callback when a disconnection occurs or if an attempt to connect failed.
     
     When this happens we schedule a retry to run after 2 minutes
     If a retry fails this method is called. We then schedule another retry. This goes on until connection succeeds
     */
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        print("didDisconnect")
        //retryConnecting()
        timer = NSTimer.scheduledTimerWithTimeInterval(1*60*2, target:self, selector: Selector("retryConnecting"), userInfo: nil, repeats: false)
        connected = false
    }
    
    /**
     Sends a message
     
     - Parameters:
     - message: message string to send
     
     It uses quality of service level 1, meaning it is guaranteed that the message will be delivered at least once to the receiver

     */
    func sendMessage(message: String){
        mqtt.publish(chatTopic, withString: message, qos: .QOS1)
    }
    
    /**
     Make sure timer is invalidated when this mqtt client is removed from memory.
     */
    deinit {
        timer?.invalidate()
    }
    
}

let chatTopic = "chat/room/sendy/topic/payment"
