//
//  PopUpViewController.swift
//  Assignment1
//
//  Created by linshun on 3/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import  GoogleSignIn

class PopUpViewController: UIViewController {
    @IBAction func closePopup(_ sender: Any) {
        self.showNavigationBar()
        removeAnimate()
        
    }
    
    @IBOutlet weak var NavigationView: UIView!
    
    @IBOutlet weak var userProfle: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var HomeButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var discoverImage: UIImageView!
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var logoutImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func ToChats(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageTableViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        // vc.modalPresentationStyle = .fullScreen
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
        
    }
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            
            let loginManager = LoginManager()
            loginManager.logOut()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! ViewController
            
            
            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func toHome(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        // vc.modalPresentationStyle = .fullScreen
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
    }
    @IBAction func toDiscover(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Discover") as! DiscoverTableViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        // vc.modalPresentationStyle = .fullScreen
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
    }
    @IBAction func toProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! PersonalDetailsViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        // vc.modalPresentationStyle = .fullScreen
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
    }
    let homeContainer: UIView =
    {  let Container = UIView()
        Container.translatesAutoresizingMaskIntoConstraints=false
        return Container
        
        
    }()
    
    let discoverContainer: UIView =
    {  let Container = UIView()
        Container.translatesAutoresizingMaskIntoConstraints=false
        return Container
        
        
    }()
    
    let profileContainer: UIView =
    {  let Container = UIView()
        Container.translatesAutoresizingMaskIntoConstraints=false
        return Container
        
        
    }()
    let chatContainer: UIView =
    {  let Container = UIView()
        Container.translatesAutoresizingMaskIntoConstraints=false
        return Container
        
        
    }()
    let logoutContainer: UIView =
    {  let Container = UIView()
        Container.translatesAutoresizingMaskIntoConstraints=false
        return Container
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.black.withAlphaComponent(0.8)
        setView()
        showAnimate()
        hideNavigationBar()
        setContainer()
        setContent()
        setProfileInformatiom()
        
        // Do any additional setup after loading the view.
    }
    private func  setProfileInformatiom()
    {
        let uid =  Auth.auth().currentUser?.uid
        if (GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            Database.database().reference().child("users").child((GIDSignIn.sharedInstance()?.currentUser.userID)!).observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as?[String:AnyObject]
                {
                    
                    self.username.text = dictionary["name"] as?String
                    self.userEmail.text = dictionary["email"] as?String
                    if let profileImageUrl = dictionary["profileImageURL"] as? String {
                        self.userProfle.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
            }
                , withCancel: nil)
        }
            
        else if(AccessToken.current?.userID != nil)
        {
            Database.database().reference().child("users").child(AccessToken.current!.userID).observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as?[String:AnyObject]
                {
                    
                    self.username.text = dictionary["name"] as?String
                    self.userEmail.text = dictionary["email"] as?String
                    if let profileImageUrl = dictionary["profileImageURL"] as? String {
                        self.userProfle.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
                
            }
                , withCancel: nil)
            
        }
        else if(uid != nil){
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as?[String:AnyObject]
                {
                    
                    self.username.text = dictionary["name"] as?String
                    self.userEmail.text = dictionary["email"] as?String
                    if let profileImageUrl = dictionary["profileImageURL"] as? String {
                        self.userProfle.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                    
                }
                
                
            }
                , withCancel: nil)
            
        }
        
    }
    private func setContainer()
    {
        NavigationView.addSubview(homeContainer)
        NavigationView.addSubview(discoverContainer)
        NavigationView.addSubview(profileContainer)
        NavigationView.addSubview(chatContainer)
        NavigationView.addSubview(logoutContainer)
        // home container
        homeContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.08).isActive=true
        // same as left and right
        homeContainer.topAnchor.constraint(equalTo:userEmail.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        homeContainer.leadingAnchor.constraint(equalTo:NavigationView.leadingAnchor).isActive=true
        homeContainer.trailingAnchor.constraint(equalTo:NavigationView.trailingAnchor).isActive=true
        
        // discover container
        discoverContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.08).isActive=true
        // same as left and right
        discoverContainer.topAnchor.constraint(equalTo:profileContainer.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        discoverContainer.leadingAnchor.constraint(equalTo:NavigationView.leadingAnchor).isActive=true
        discoverContainer.trailingAnchor.constraint(equalTo:NavigationView.trailingAnchor).isActive=true
        
        // profile container
        profileContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.08).isActive=true
        // same as left and right
        profileContainer.topAnchor.constraint(equalTo:homeContainer.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        profileContainer.leadingAnchor.constraint(equalTo:NavigationView.leadingAnchor).isActive=true
        profileContainer.trailingAnchor.constraint(equalTo:NavigationView.trailingAnchor).isActive=true
        
        // chat container
        chatContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.08).isActive=true
        // same as left and right
        chatContainer.topAnchor.constraint(equalTo:discoverContainer.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        chatContainer.leadingAnchor.constraint(equalTo:NavigationView.leadingAnchor).isActive=true
        chatContainer.trailingAnchor.constraint(equalTo:NavigationView.trailingAnchor).isActive=true
        
        // discover container
        logoutContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.08).isActive=true
        // same as left and right
        logoutContainer.topAnchor.constraint(equalTo:chatContainer.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        logoutContainer.leadingAnchor.constraint(equalTo:NavigationView.leadingAnchor).isActive=true
        logoutContainer.trailingAnchor.constraint(equalTo:NavigationView.trailingAnchor).isActive=true
    }
    private func setContent()
    {
        // close button
        closeButton.translatesAutoresizingMaskIntoConstraints =  false
        closeButton.trailingAnchor.constraint(equalTo: NavigationView.trailingAnchor, constant: -20).isActive = true
        closeButton.topAnchor.constraint(equalTo: NavigationView.topAnchor, constant: 20).isActive=true
        // user profile image
        userProfle.translatesAutoresizingMaskIntoConstraints = false
        
        userProfle.centerXAnchor.constraint(equalTo: NavigationView.centerXAnchor).isActive = true
        userProfle.topAnchor.constraint(equalTo: NavigationView.topAnchor,constant: self.view.frame.height * 0.03).isActive = true
        userProfle.layer.cornerRadius = 40
        userProfle.layer.masksToBounds = true
        userProfle.contentMode = .scaleAspectFill
        // username label
        username.translatesAutoresizingMaskIntoConstraints = false
        username.centerXAnchor.constraint(equalTo: NavigationView.centerXAnchor).isActive = true
        username.topAnchor.constraint(equalTo: userProfle.bottomAnchor,constant: self.view.frame.height * 0.03).isActive = true
        username.font = username.font.withSize(self.view.frame.height * 0.03)
        
        // user email label
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        userEmail.centerXAnchor.constraint(equalTo: NavigationView.centerXAnchor).isActive = true
        userEmail.topAnchor.constraint(equalTo: username.bottomAnchor,constant: self.view.frame.height * 0.03).isActive = true
        userEmail.font = userEmail.font.withSize(self.view.frame.height * 0.03)
        
        // home image
        homeImage.translatesAutoresizingMaskIntoConstraints = false
        homeImage.leadingAnchor.constraint(equalTo: homeContainer.leadingAnchor).isActive = true
        homeImage.centerYAnchor.constraint(equalTo: homeContainer.centerYAnchor).isActive = true
        homeImage.heightAnchor.constraint(equalTo: homeContainer.heightAnchor, multiplier: 1).isActive = true
        homeImage.widthAnchor.constraint(equalTo: homeContainer.widthAnchor, multiplier: 0.3).isActive = true
        
        // home button
        HomeButton.translatesAutoresizingMaskIntoConstraints = false
        HomeButton.leadingAnchor.constraint(equalTo: homeContainer.leadingAnchor).isActive = true
        HomeButton.topAnchor.constraint(equalTo: homeContainer.topAnchor).isActive = true
        HomeButton.bottomAnchor.constraint(equalTo: homeContainer.bottomAnchor).isActive = true
        HomeButton.trailingAnchor.constraint(equalTo: homeContainer.trailingAnchor).isActive = true
        HomeButton.titleLabel?.font=HomeButton.titleLabel?.font.withSize(self.view.frame.height * 0.02)
        
        homeContainer.addSubview(homeImage)
        homeContainer.addSubview(HomeButton)
        
        // discover image
        discoverImage.translatesAutoresizingMaskIntoConstraints = false
        discoverImage.leadingAnchor.constraint(equalTo: discoverContainer.leadingAnchor).isActive = true
        discoverImage.centerYAnchor.constraint(equalTo: discoverContainer.centerYAnchor).isActive = true
        discoverImage.heightAnchor.constraint(equalTo: discoverContainer.heightAnchor, multiplier: 1).isActive = true
        discoverImage.widthAnchor.constraint(equalTo: discoverContainer.widthAnchor, multiplier: 0.3).isActive = true
        
        // discover button
        discoverButton.translatesAutoresizingMaskIntoConstraints = false
        discoverButton.leadingAnchor.constraint(equalTo: discoverContainer.leadingAnchor).isActive = true
        discoverButton.topAnchor.constraint(equalTo: discoverContainer.topAnchor).isActive = true
        discoverButton.bottomAnchor.constraint(equalTo: discoverContainer.bottomAnchor).isActive = true
        discoverButton.trailingAnchor.constraint(equalTo: discoverContainer.trailingAnchor).isActive = true
        discoverButton.titleLabel?.font=discoverButton.titleLabel?.font.withSize(self.view.frame.height * 0.02)
        
        discoverContainer.addSubview(discoverImage)
        discoverContainer.addSubview(discoverButton)
        
        // profile image
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: profileContainer.centerYAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileContainer.heightAnchor, multiplier: 1).isActive = true
        profileImage.widthAnchor.constraint(equalTo: profileContainer.widthAnchor, multiplier: 0.3).isActive = true
        
        // profile button
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor).isActive = true
        profileButton.topAnchor.constraint(equalTo: profileContainer.topAnchor).isActive = true
        profileButton.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor).isActive = true
        profileButton.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor).isActive = true
        profileButton.titleLabel?.font=discoverButton.titleLabel?.font.withSize(self.view.frame.height * 0.02)
        
        profileContainer.addSubview(profileImage)
        profileContainer.addSubview(profileButton)
        
        // chat image
        chatImage.translatesAutoresizingMaskIntoConstraints = false
        chatImage.leadingAnchor.constraint(equalTo: chatContainer.leadingAnchor).isActive = true
        chatImage.centerYAnchor.constraint(equalTo: chatContainer.centerYAnchor).isActive = true
        chatImage.heightAnchor.constraint(equalTo: chatContainer.heightAnchor, multiplier: 1).isActive = true
        chatImage.widthAnchor.constraint(equalTo: chatContainer.widthAnchor, multiplier: 0.3).isActive = true
        
        // chat button
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.leadingAnchor.constraint(equalTo: chatContainer.leadingAnchor).isActive = true
        chatButton.topAnchor.constraint(equalTo: chatContainer.topAnchor).isActive = true
        chatButton.bottomAnchor.constraint(equalTo: chatContainer.bottomAnchor).isActive = true
        chatButton.trailingAnchor.constraint(equalTo: chatContainer.trailingAnchor).isActive = true
        chatButton.titleLabel?.font=chatButton.titleLabel?.font.withSize(self.view.frame.height * 0.02)
        
        chatContainer.addSubview(chatImage)
        chatContainer.addSubview(chatButton)
        
        // profile image
        logoutImage.translatesAutoresizingMaskIntoConstraints = false
        logoutImage.leadingAnchor.constraint(equalTo: logoutContainer.leadingAnchor).isActive = true
        logoutImage.centerYAnchor.constraint(equalTo: logoutContainer.centerYAnchor).isActive = true
        logoutImage.heightAnchor.constraint(equalTo: logoutContainer.heightAnchor, multiplier: 1).isActive = true
        logoutImage.widthAnchor.constraint(equalTo: logoutContainer.widthAnchor, multiplier: 0.3).isActive = true
        
        // profile button
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.leadingAnchor.constraint(equalTo: logoutContainer.leadingAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: logoutContainer.topAnchor).isActive = true
        logoutButton.bottomAnchor.constraint(equalTo: logoutContainer.bottomAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: logoutContainer.trailingAnchor).isActive = true
        logoutButton.titleLabel?.font=logoutButton.titleLabel?.font.withSize(self.view.frame.height * 0.02)
        
        logoutContainer.addSubview(logoutImage)
        logoutContainer.addSubview(logoutButton)
    }
    private func setView()
    {
        NavigationView.translatesAutoresizingMaskIntoConstraints = false
        NavigationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        NavigationView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -self.view.frame.width * 0.2).isActive = true
        NavigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        NavigationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25,animations:
            {
                self.view.alpha=1.0
                self.view.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25,animations:
            {
                
                self.view.transform = CGAffineTransform(scaleX: 1.3,y: 1.3)
                self.view.alpha=0.0
        },completion: {(finished: Bool) in if(finished)
        {
            self.view.removeFromSuperview()
            
            }
        }
        )
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
