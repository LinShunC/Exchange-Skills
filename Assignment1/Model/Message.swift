//
//  Message.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    var imageUrl: String?
    var imageWidth: NSNumber?
    var videoUrl: String?
     var imageHeight: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
          self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
          self.imageHeight = dictionary["imageHeight"] as? NSNumber
         self.videoUrl = dictionary["videoUrl"] as? String
    }
    func chatPartnerId() -> String? {
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            return fromId == GIDSignIn.sharedInstance()?.currentUser.userID ? toId : fromId
        }
        else if(AccessToken.current?.userID != nil)
            
        {
            return fromId == AccessToken.current?.userID ? toId : fromId
            
            
        }
            
        else 
        {
            return fromId == Auth.auth().currentUser?.uid ? toId : fromId
        }
        
        
    }
    
}
