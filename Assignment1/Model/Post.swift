
import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class Post: NSObject {
    
    
    
    var postTitle: String?
    var address: String?
    var Description: String?
    var activityTime: String?
    var activityDate: String?
    var postDate: String?
    var ActicityURL: String?
    var posterId: String?
    
    init(dictionary: [String: Any]) {
        self.postTitle = dictionary["postTitle"] as? String
        self.address = dictionary["address"] as? String
        self.Description = dictionary["description"] as? String
        self.activityTime = dictionary["activityTime"] as? String
        self.activityDate = dictionary["activityDate"] as? String
        self.postDate = dictionary["postDate"] as? String
        self.ActicityURL = dictionary["ActicityURL"] as? String
        self.posterId = dictionary["posterId"] as? String
    }
    
    
}
