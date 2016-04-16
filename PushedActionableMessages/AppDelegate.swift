//
//  AppDelegate.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 10/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var  mqttClient = MQTTClient()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /// Register for remote notifications
            registerForPushNotifications(application)
        
        /// Check if launched from notification
        if let _ = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            
            print("launched from notification")
            
        }

        /// set main view
        window!.rootViewController = ViewController()
        window!.makeKeyAndVisible()
        
        /// this lines enables moving of text entry controls to accomodate keyboard
        IQKeyboardManager.sharedManager().enable = true
        
        mqttClient.connect()
        
        return true
    }
    
    /**
     Method that we call on app launch to register for notifications and get token
     
     - Parameter application: the application object for which we need notifications
     */
    func registerForPushNotifications(application: UIApplication) {
        
        /// create pay action
        let viewAction = UIMutableUserNotificationAction()
        viewAction.identifier = payIdentifier
        viewAction.title = "Pay"
        viewAction.activationMode = .Foreground
        
        /// create payment category and set pay actions
        let payCategory = UIMutableUserNotificationCategory()
        payCategory.identifier = payCategoryId
        payCategory.setActions([viewAction], forContext: .Default)
        
        /// create chat category. It has no actions
        let chatCategory = UIMutableUserNotificationCategory()
        chatCategory.identifier = chatCategoryId
        
        /**
         store notifications settings for the type we need
         - .Badge allows the app to display a number on the corner of the app’s icon
         - .Sound allows the app to play a sound
         - .Alert allows the app to display text
         
         Then specify the categories we need to handle
        */
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: [payCategory, chatCategory])
        
        /// register for notifications with the defined settings. This prompts user to allow us to receive notifications
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    /**
     Callback method that is called after user is done with notifications settings alert
     */
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        /// if user allows register for remote notifications
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    /**
     Called to inform us about the status of registerForRemoteNotifications()
     
     - Parameter application: the application object that will receive notifications
     - Parameter deviceToken: registration token that we will use to send messages to the application. It uniquely identifies this app on a device
     */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        ///Convert token to a hex format string. We will need it in that format to send messages
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        
        /// populate parameters object with token string and unique device id. The device id ensures we save only one token for each device
        var parameters = [String: AnyObject]()
        parameters["registrationToken"] = tokenString
        parameters["deviceId"] = Utils.getUUID()
        
        //# TODO: implement retries in case registration fails
        
       ///saves token on server to use in sending messages
        HTTPClient.get("register", parameters: parameters, responseHandlerDelegate: ResponseHandler(background: true, viewController: nil))
    }
    
    /**
     Called to inform us about failer of registerForRemoteNotifications()
     
     - Parameter application: the application object that attempted to register for notifications
     - Parameter error: the erro object. Contains the error message
     */
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
            print("Failed to register:", error)

    }
    
    /**
     Called to handle receive notifications when 
     - App is running and in the foreground, the push notification will not be shown, but this method will be called immediately
     OR
     - The app was running or suspended in the background and the user brings it to the foreground by tapping the push notification
     
     - Parameter application: the application object that registered for notifications
     - Parameter userInfo: Contains the notification payload
     */
    func application( application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
            print("app was running \(userInfo)")
            
            /// Check if action is pay and prompt user to pay with the amount due
            if let identifier = userInfo["action_identifier"] as? String, amount = userInfo["amount"] as? String where identifier == payIdentifier{
                showAlert(amount)
            }else{
                ///Otherwise it is a chat message and we add it to our message list if the main view has been initialized
                if let rootViewController = window?.rootViewController as? ViewController, aps = userInfo["aps"] as? [String: AnyObject], message = aps["alert"] as? String, sender = userInfo["sender"] as? String {
                    rootViewController.messageList?.addMessage(Message(message:message, sender: sender))
                }
            }
    }
    
    /**
     This is the callback you get when the app is opened by a custom action
     
     - Parameter application: the application object that registered for notifications
     - Parameter identifier: the custom action identifier
     - Parameter userInfo: Contains the notification payload
     - Parameter completionHandler: completion handler closure that needs to be called after handling notification
     */
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("handleActionWithIdentifier \(userInfo)")

        ///Ensure action is pay and prompt user to pay with the amount due
        if identifier == payIdentifier, let amount = userInfo["amount"] as? String{
           showAlert(amount)
        }
        
        completionHandler()
    }
    
    /**
     Creates payment alert and presents it
     
     - Parameter amount: the amount due
     */
    func showAlert(amount: String){
        let alert = UIAlertController(
            title: "Payment", message: String(format: Utils.getString("payment_message"), amount), preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler {
                (tf:UITextField) in
                tf.keyboardType = .NumberPad
                tf.placeholder = amount
        }
        
        alert.addAction(UIAlertAction(
            title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(
            title: "OK", style: .Default, handler: alertHandler))
        
        window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Handles actions when alert buttons are tapped
     
     - Parameter act: the action selected by user
     */
    func alertHandler(act:UIAlertAction) {
     //# TODO: proceed with payment or cancel depending on user selection              
    }
    
   

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
       
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
  
 

}

