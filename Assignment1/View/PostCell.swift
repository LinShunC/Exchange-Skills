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

class PostCell : UITableViewCell
    
{
    var post:Post?
    {
        didSet{
            self.ActivityImageView.loadImageUsingCacheWithUrlString(post!.ActicityURL!)
            self.titleLabel.text = post!.postTitle!
            let ref = Database.database().reference().child("users").child(post!.posterId!).child("profileImageURL")
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let profileUrl =  snapshot.value  as! String
                
                // Get user value
                
                self.profileImageView.loadImageUsingCacheWithUrlString(profileUrl)
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
            
            
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    let ActivityImageView :UIImageView =
    {
        let imageView = UIImageView()
        // imageView.image = UIImage(named: "discover")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "nedstark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        imageView.layer.masksToBounds = false
        
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        
        //imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let titleLabel: UILabel  =
    {
        let label = UILabel()
        // label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init( style: .subtitle   , reuseIdentifier: reuseIdentifier)
        addSubview(ActivityImageView)
        addSubview(titleLabel)
        addSubview(profileImageView)
        //constrain
        ActivityImageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor).isActive = true
        ActivityImageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        ActivityImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        ActivityImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        profileImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:60 ).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
        titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

