//
//  UserCell.swift
//  gameofchats
//
//  Created by Brian Voong on 7/8/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import  FBSDKLoginKit

class UserCell : UITableViewCell
    
{
    var message:Message?
    {
        didSet{
            setupNameAndProfileImage()
            detailTextLabel?.text = message!.text
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
            
            
        }
    }
    fileprivate func setupNameAndProfileImage() {
        let chatPartnerId: String?
        
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            if (message?.fromId == GIDSignIn.sharedInstance()?.currentUser.userID)
            {
                setupNameAndProfileImage2(uid: message!.toId!)
            }
            else
            {
                setupNameAndProfileImage2(uid: message!.fromId!)
            }
        }
        else if ( AccessToken.current?.userID != nil)
        {
            if (message?.fromId == AccessToken.current?.userID)
            {
                setupNameAndProfileImage2(uid: message!.toId!)
            }
            else
            {
                setupNameAndProfileImage2(uid: message!.fromId!)
            }
        }
        else if(Auth.auth().currentUser?.uid != nil)
        {
            if (message?.fromId == Auth.auth().currentUser?.uid )
            {
                setupNameAndProfileImage2(uid: message!.toId!)
            }
            else
            {
                setupNameAndProfileImage2(uid: message!.fromId!)
            }
        }
        
        
        
    }
    fileprivate func setupNameAndProfileImage2( uid: String)
    {
        
        
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.textLabel?.text = dictionary["name"] as? String
                
                if let profileImageUrl = dictionary["profileImageURL"] as? String {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
            }
            
        }, withCancel: nil)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    let profileImageView :UIImageView =
    {
        let imageView = UIImageView()
        // imageView.image = UIImage(named: "discover")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let timeLabel: UILabel  =
    {
        let label = UILabel()
        // label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init( style: .subtitle   , reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        //constrain
        profileImageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

