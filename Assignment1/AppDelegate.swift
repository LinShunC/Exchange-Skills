//
//  AppDelegate.swift
//  Assignment1
//
//  Created by linshun on 31/12/19.
//  Copyright © 2019 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FBSDKCoreKit
import FBSDKCoreKit
import GoogleMaps
import GooglePlaces





@UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate{
    
 

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool
    {
        
        let handledFB = ApplicationDelegate.shared.application(application, open: url, options: options)
        let handledGoogle = GIDSignIn.sharedInstance().handle(url)
        return handledFB || handledGoogle
        
    }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        // google login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
       
        
     
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GMSServices.provideAPIKey("AIzaSyCzfj795Ltzogw2xUb1kr4XR1eBUH97YPo")
        GMSPlacesClient.provideAPIKey("AIzaSyCzfj795Ltzogw2xUb1kr4XR1eBUH97YPo")

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }



}

