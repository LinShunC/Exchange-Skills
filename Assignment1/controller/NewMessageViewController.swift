//
//  NewMessageViewController.swift
//  Assignment1
//
//  Created by linshun on 18/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    
    let imageCache = NSCache<NSString, AnyObject>()
    let cellId = "cellId"
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        // Do any additional setup after loading the view.
    }
    
    @objc private func handleBack()
    {
        dismiss(animated: true, completion: nil)
    }
    func fetchUsers() {
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                
                //if you use this setter, your app will crash if your class properties don't exactly match up with the firebase dictionary keys
                self.users.append(user)
                
                //this will crash because of background thread, so lets use dispatch_async to fix
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                //                user.name = dictionary["name"]
            }
            
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    var messagesController: MessageTableViewController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion:
            {
                let user = self.users[indexPath.row]
                self.messagesController?.showChatController(user)
        })
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        if let profileImageUrl = user.profileImageURL{
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            
        }
        
        
        return cell
        
    }
    
}
