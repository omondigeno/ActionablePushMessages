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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Register for remote notifications
            registerForPushNotifications(application)
        
        // Check if launched from notification
        if let _ = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            //let aps = notification["aps"] as! [String: AnyObject]
            print("launched from notification")
            
        }

        window!.rootViewController = ViewController()
        IQKeyboardManager.sharedManager().enable = true
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let viewAction = UIMutableUserNotificationAction()
        viewAction.identifier = payIdentifier
        viewAction.title = "Pay"
        viewAction.activationMode = .Foreground
        
        let newsCategory = UIMutableUserNotificationCategory()
        newsCategory.identifier = "PAYMENT_CATEGORY"
        newsCategory.setActions([viewAction], forContext: .Default)
        
        let notificationSettings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert], categories: [newsCategory])
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        
        var parameters = [String: AnyObject]()
        parameters["registrationToken"] = tokenString
        parameters["deviceId"] = Utils.getUUID()
        
        //# TODO: implement retries in case registration fails
        
        HTTPClient.get("register", parameters: parameters, responseHandlerDelegate: ResponseHandler(background: true, viewController: nil))
    }
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
            print("Failed to register:", error)

    }
    
    func application( application: UIApplication,
        didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
            print("app was running \(userInfo)")
            
            if let identifier = userInfo["action_identifier"] as? String, amount = userInfo["amount"] as? String where identifier == payIdentifier{
                //# TODO: ideally use local notification to avoid rudely interrupting user
                showAlert(amount)
            }
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        print("handleActionWithIdentifier \(userInfo)")

        if identifier == payIdentifier, let amount = userInfo["amount"] as? String{
           showAlert(amount)
        }
        
        completionHandler()
    }
    
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
    
    func alertHandler(act:UIAlertAction) {
                   
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

