//
//  MessageTableViewController.swift
//  Assignment1
//
//  Created by linshun on 20/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import  GoogleSignIn

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class MessageTableViewController: UITableViewController {
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleNavigation()
        tableView.allowsMultipleSelectionDuringEditing = true
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let uid = getUserID() else {return }
          let message = self.messages[indexPath.row]
      if let chatPartnerId = message.chatPartnerId() {
                   Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                       
                       if error != nil {
                           print("Failed to delete message:", error!)
                           return
                       }
                       
                       self.messagesDictionary.removeValue(forKey: chatPartnerId)
                       self.attemptReloadOfTable()
                       
                       //                //this is one way of updating the table, but its actually not that safe..
                       //                self.messages.removeAtIndex(indexPath.row)
                       //                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                       
                   })
               }
    }
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    private func  observeUserMessage()
    {
        
        
        if ( GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            getMessage(uid: (GIDSignIn.sharedInstance()?.currentUser.userID)!)
        }
        else if( AccessToken.current?.userID != nil)
        {
            getMessage(uid: AccessToken.current!.userID)
        }
        else if (Auth.auth().currentUser?.uid != nil)
        {
            getMessage(uid: Auth.auth().currentUser!.uid)
        }
        
    }
    
    private func getMessage(uid : String)
    {
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            
            print(snapshot.key)
            print(self.messagesDictionary)
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        },withCancel: nil)
    }
    fileprivate func fetchMessageWithMessageId(_ messageId: String)
    {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatParterId = message.chatPartnerId() {
                    self.messagesDictionary[chatParterId] = message
                    
                    
                }
                
                self.attemptReloadOfTable()
            }
            
        }, withCancel: nil)
        
        
    }
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    var timer: Timer?
    
    @objc func handleReloadTable() {
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            if let timestamp1 = message1.timestamp, let timestamp2 = message2.timestamp {
                return timestamp1.intValue > timestamp2.intValue
            }
            return false
        })
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    private func handleNavigation()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        let image = UIImage(named: "test")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain
            , target: self, action: #selector(handleNewMessag))
        navigationItem.rightBarButtonItem?.image = image
        
        let uid = Auth.auth().currentUser?.uid
        
        if ( GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            Database.database().reference().child("users").child((GIDSignIn.sharedInstance()?.currentUser.userID)!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]   {
                    let name = dictionary["name"] as? String
                    let url =  dictionary["profileImageURL"] as? String
                    self.setupNavBarWithUser(profileImageUrl:  url!, name: name!)
                }
                
            }, withCancel: nil)}
            
            
        else if( AccessToken.current?.tokenString != nil)
        {
            Database.database().reference().child("users").child( AccessToken.current!.userID ).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]   {
                    let name = dictionary["name"] as? String
                    let url =  dictionary["profileImageURL"] as? String
                    self.setupNavBarWithUser(profileImageUrl:  url!, name: name!)
                }
                
            }, withCancel: nil)}
            
            
        else if (uid != nil){
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]   {
                    let name = dictionary["name"] as? String
                    let url =  dictionary["profileImageURL"] as? String
                    self.setupNavBarWithUser(profileImageUrl:  url!, name: name!)
                }
                
            }, withCancel: nil)}
    }
    
    func setupNavBarWithUser(profileImageUrl: String , name: String) {
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessage()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        
        
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        
    }
    @objc func showChatController(_ user: User) {
        let chalogController =  chatlogController(collectionViewLayout: UICollectionViewFlowLayout())
        chalogController.user = user
        navigationController?.pushViewController(chalogController, animated: true)
        
        
    }
    
    @objc private func handleBack()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        // vc.modalPresentationStyle = .fullScreen
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
        
    }
    @objc private func handleNewMessag()
    {
        let newMessageController = NewMessageViewController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
        
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
    
        
        let message = messages[indexPath.row]
        
        cell.message = message
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            user.id = chatPartnerId
            self.showChatController(user)
            
        }, withCancel: nil)
        
        //  showChatController()
    }
    
}
func getUserID() -> String? {
    if(GIDSignIn.sharedInstance()?.currentUser != nil)
    {
        return (GIDSignIn.sharedInstance()?.currentUser.userID)!
        
    }
    else if(AccessToken.current?.userID != nil)
    {
        return ( AccessToken.current!.userID)
        
        
    }
    else if(Auth.auth().currentUser?.uid != nil)
    {
        
        return (Auth.auth().currentUser!.uid)
    }
    else
    {
        return nil
    }
}
