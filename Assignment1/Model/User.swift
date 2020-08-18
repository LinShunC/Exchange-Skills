//
//  User.swift
//  Assignment1
//
//  Created by linshun on 18/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var email: String?
    var profileImageURL: String?
    var id:String?
    
    
    init (dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageURL = dictionary["profileImageURL"] as? String
    }
}

