//
//  PostDetailsViewController.swift
//  Assignment1
//
//  Created by linshun on 2/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
class PostDetailsViewController: UIViewController {
    var post: Post? {
        didSet {
            
            
        }
    }
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var posterProfileImage: UIImageView!
    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    @IBOutlet weak var addressInfo: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailInfo: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    @IBOutlet weak var activityDateInfo: UILabel!
    @IBOutlet weak var activityTimeLabel: UILabel!
    @IBOutlet weak var activityTimeInfo: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionInfo: UITextView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBAction func popup(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpScreen") as!PopUpViewController
        self.addChild(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    
    @IBAction func Chat(_ sender: Any) {
        let ref = Database.database().reference().child("users").child(post!.posterId!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User(dictionary: dictionary)
            let chalogController =  chatlogController(collectionViewLayout: UICollectionViewFlowLayout())
            chalogController.user = user
            user.id = self.post?.posterId
            self.navigationController?.pushViewController(chalogController, animated: true)
            
        }, withCancel: nil)
        
    }
    
    
    let NavigationContainer: UIView =
    {  let NavigationContainer = UIView()
        NavigationContainer.translatesAutoresizingMaskIntoConstraints=false
        return NavigationContainer
        
        
    }()
    let imageContainer: UIView =
    {  let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints=false
        return imageContainer
        
        
    }()
    
    let posterContainer: UIView =
    {  let posterContainer = UIView()
        posterContainer.translatesAutoresizingMaskIntoConstraints=false
        return posterContainer
    }()
    let addressContainer: UIView =
    {  let addressContainer = UIView()
        addressContainer.translatesAutoresizingMaskIntoConstraints=false
        return addressContainer
    }()
    let emailContainer: UIView =
    {  let emailContainer = UIView()
        emailContainer.translatesAutoresizingMaskIntoConstraints=false
        return emailContainer
    }()
    let dateContainer: UIView =
    {  let dateContainer = UIView()
        dateContainer.translatesAutoresizingMaskIntoConstraints=false
        return dateContainer
    }()
    let timeContainer: UIView =
    {  let timeContainer = UIView()
        timeContainer.translatesAutoresizingMaskIntoConstraints=false
        return timeContainer
    }()
    let descriptionContainer: UIView =
    {  let descriptionContainer = UIView()
        descriptionContainer.translatesAutoresizingMaskIntoConstraints=false
        return descriptionContainer
    }()
    let userContainer: UIView =
    {  let userContainer = UIView()
        userContainer.translatesAutoresizingMaskIntoConstraints=false
        return userContainer
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNavigationBar()
        setContainer()
        setContent()
        handleNavigation()
    }
    private func handleNavigation()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
    }
    @objc private func handleBack()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Discover") as! DiscoverTableViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        // vc.modalPresentationStyle = .fullScreen
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
        
    }
    private func setContent()
    {
        // POST  image
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.heightAnchor.constraint(equalTo:imageContainer.heightAnchor , multiplier: 1).isActive=true
        // same as left and right
        postImage.bottomAnchor.constraint(equalTo:imageContainer.bottomAnchor).isActive=true
        postImage.trailingAnchor.constraint(equalTo:imageContainer.trailingAnchor).isActive=true
        postImage.topAnchor.constraint(equalTo:imageContainer.topAnchor).isActive=true
        postImage.leadingAnchor.constraint(equalTo:imageContainer.leadingAnchor).isActive=true
        postImage.loadImageUsingCacheWithUrlString(post!.ActicityURL!)
        
        imageContainer.addSubview(postImage)
        // post title
        postTitle.translatesAutoresizingMaskIntoConstraints = false
        postTitle.topAnchor.constraint(equalTo:imageContainer.bottomAnchor).isActive=true
        postTitle.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor,constant: self.view.frame.width * 0.03).isActive=true
        postTitle.font = postTitle.font.withSize(self.view.frame.height * 0.03)
        postTitle.text = post?.postTitle
        //post date
        postDate.translatesAutoresizingMaskIntoConstraints = false
        postDate.centerYAnchor.constraint(equalTo:posterContainer.centerYAnchor).isActive=true
        postDate.leadingAnchor.constraint(equalTo:posterContainer.leadingAnchor,constant: self.view.frame.width * 0.03).isActive=true
        postDate.font = postDate.font.withSize(self.view.frame.height * 0.02)
        postDate.text = post?.activityDate
        // poster profile image
        posterProfileImage.translatesAutoresizingMaskIntoConstraints = false
        posterProfileImage.centerYAnchor.constraint(equalTo:posterContainer.centerYAnchor).isActive=true
        
        posterProfileImage.leadingAnchor.constraint(equalTo:postDate.trailingAnchor,constant: self.view.frame.width * 0.12).isActive=true
        
        posterProfileImage.heightAnchor.constraint(equalTo:posterContainer.heightAnchor , multiplier: 0.8).isActive=true
        posterProfileImage.widthAnchor.constraint(equalTo:posterContainer.widthAnchor , multiplier: 0.1).isActive=true
        
        posterProfileImage.layer.masksToBounds = false
        
        posterProfileImage.layer.cornerRadius = 15
        posterProfileImage.clipsToBounds = true
        
        
        
        
        
        // post name
        posterName.translatesAutoresizingMaskIntoConstraints = false
        posterName.centerYAnchor.constraint(equalTo:posterContainer.centerYAnchor).isActive=true
        posterName.leadingAnchor.constraint(equalTo:posterProfileImage.trailingAnchor,constant: self.view.frame.width * 0.15).isActive=true
        posterName.font = posterName.font.withSize(self.view.frame.height * 0.02)
        
        posterContainer.addSubview(postDate)
        posterContainer.addSubview(posterName)
        posterContainer.addSubview(posterProfileImage)
        //  address label
        AddressLabel.translatesAutoresizingMaskIntoConstraints = false
        AddressLabel.topAnchor.constraint(equalTo:addressContainer.topAnchor).isActive=true
        AddressLabel.bottomAnchor.constraint(equalTo:addressContainer.bottomAnchor).isActive=true
        AddressLabel.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor,constant: 10).isActive=true
        AddressLabel.font = AddressLabel.font.withSize(self.view.frame.height * 0.02)
        
        // address info
        
        addressInfo.translatesAutoresizingMaskIntoConstraints = false
        addressInfo.leadingAnchor.constraint(equalTo:AddressLabel.trailingAnchor,constant: 60).isActive=true
        addressInfo.topAnchor.constraint(equalTo:addressContainer.topAnchor ).isActive=true
        addressInfo.bottomAnchor.constraint(equalTo:addressContainer.bottomAnchor ).isActive=true
        addressInfo.font = addressInfo.font.withSize(self.view.frame.height * 0.02)
        addressInfo.text = post?.address
        
        addressContainer.addSubview(AddressLabel)
        addressContainer.addSubview(addressInfo)
        
        //  email label
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo:emailContainer.topAnchor).isActive=true
        emailLabel.bottomAnchor.constraint(equalTo:emailContainer.bottomAnchor).isActive=true
        emailLabel.leadingAnchor.constraint(equalTo:AddressLabel.leadingAnchor).isActive=true
        emailLabel.font = emailLabel.font.withSize(self.view.frame.height * 0.02)
        // email info
        
        emailInfo.translatesAutoresizingMaskIntoConstraints = false
        emailInfo.leadingAnchor.constraint(equalTo:addressInfo.leadingAnchor).isActive=true
        emailInfo.topAnchor.constraint(equalTo:emailContainer.topAnchor ).isActive=true
        emailInfo.bottomAnchor.constraint(equalTo:emailContainer.bottomAnchor ).isActive=true
        emailInfo.font = emailInfo.font.withSize(self.view.frame.height * 0.02)
        emailContainer.addSubview(emailLabel)
        emailContainer.addSubview(addressInfo)
        
        //  date label
        activityDateLabel.translatesAutoresizingMaskIntoConstraints = false
        activityDateLabel.topAnchor.constraint(equalTo:dateContainer.topAnchor).isActive=true
        activityDateLabel.bottomAnchor.constraint(equalTo:dateContainer.bottomAnchor).isActive=true
        activityDateLabel.leadingAnchor.constraint(equalTo:emailLabel.leadingAnchor).isActive=true
        activityDateLabel.font = activityDateLabel.font.withSize(self.view.frame.height * 0.02)
        // date info
        
        activityDateInfo.translatesAutoresizingMaskIntoConstraints = false
        activityDateInfo.leadingAnchor.constraint(equalTo:activityDateLabel.trailingAnchor,constant: 28).isActive=true
        activityDateInfo.topAnchor.constraint(equalTo:dateContainer.topAnchor ).isActive=true
        activityDateInfo.bottomAnchor.constraint(equalTo:dateContainer.bottomAnchor ).isActive=true
        activityDateInfo.font = activityDateInfo.font.withSize(self.view.frame.height * 0.02)
        activityDateInfo.text = post?.activityDate
        dateContainer.addSubview(activityDateLabel)
        dateContainer.addSubview(activityDateInfo)
        
        //  time label
        activityTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        activityTimeLabel.topAnchor.constraint(equalTo:timeContainer.topAnchor).isActive=true
        activityTimeLabel.bottomAnchor.constraint(equalTo:timeContainer.bottomAnchor).isActive=true
        activityTimeLabel.leadingAnchor.constraint(equalTo:activityDateLabel.leadingAnchor).isActive=true
        activityTimeLabel.font = activityTimeLabel.font.withSize(self.view.frame.height * 0.02)
        // date info
        
        activityTimeInfo.translatesAutoresizingMaskIntoConstraints = false
        activityTimeInfo.leadingAnchor.constraint(equalTo:activityDateInfo.leadingAnchor).isActive=true
        activityTimeInfo.topAnchor.constraint(equalTo:timeContainer.topAnchor ).isActive=true
        activityTimeInfo.bottomAnchor.constraint(equalTo:timeContainer.bottomAnchor ).isActive=true
        activityTimeInfo.font = activityTimeInfo.font.withSize(self.view.frame.height * 0.02)
        activityTimeInfo.text = post?.activityTime
        timeContainer.addSubview(activityTimeLabel)
        timeContainer.addSubview(activityTimeInfo)
        // description label
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo:timeContainer.bottomAnchor,constant:self.view.frame.height * 0.01 ).isActive=true
        descriptionLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor ).isActive=true
        //description content
        
        descriptionInfo.translatesAutoresizingMaskIntoConstraints = false
        // descriptionInfo.topAnchor.constraint(equalTo:view.topAnchor,constant:self.view.frame.height * 0.01 ).isActive=true
        
        descriptionInfo.topAnchor.constraint(equalTo:descriptionContainer.topAnchor ).isActive=true
        descriptionInfo.leadingAnchor.constraint(equalTo:descriptionContainer.leadingAnchor ).isActive=true
        descriptionInfo.bottomAnchor.constraint(equalTo:descriptionContainer.bottomAnchor ).isActive=true
        descriptionInfo.trailingAnchor.constraint(equalTo:descriptionContainer.trailingAnchor ).isActive=true
        
        
        
        descriptionInfo.font = descriptionInfo.font?.withSize(self.view.frame.height * 0.02)
        descriptionInfo.text = post?.Description
        
        
        
        descriptionContainer.addSubview(descriptionInfo)
        
        //user profile image
        userProfileImage.translatesAutoresizingMaskIntoConstraints = false
        userProfileImage.centerYAnchor.constraint(equalTo:userContainer.centerYAnchor).isActive=true
        
        userProfileImage.leadingAnchor.constraint(equalTo:userContainer.leadingAnchor,constant: self.view.frame.width * 0.12).isActive=true
        
        userProfileImage.heightAnchor.constraint(equalTo:posterContainer.heightAnchor , multiplier: 1).isActive=true
        userProfileImage.widthAnchor.constraint(equalTo:posterContainer.widthAnchor , multiplier: 0.1).isActive=true
        userProfileImage.layer.masksToBounds = false
        
        userProfileImage.layer.cornerRadius = 15
        userProfileImage.clipsToBounds = true
        
        if(GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            loadCurrentUserImage(userid:(GIDSignIn.sharedInstance()?.currentUser.userID)!)
        }
        else if ( AccessToken.current?.userID != nil)
        {
            loadCurrentUserImage(userid:(AccessToken.current?.userID)!)
        }
        else if(Auth.auth().currentUser?.uid != nil)
        {
            loadCurrentUserImage(userid:(Auth.auth().currentUser?.uid)!)
        }
        
        
        //chat button
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.centerYAnchor.constraint(equalTo:userContainer.centerYAnchor).isActive=true
        
        chatButton.leadingAnchor.constraint(equalTo:userProfileImage.trailingAnchor,constant: self.view.frame.width * 0.1).isActive=true
        chatButton.trailingAnchor.constraint(equalTo:userContainer.trailingAnchor,constant: -self.view.frame.width * 0.1).isActive=true
        
        chatButton.heightAnchor.constraint(equalTo:posterContainer.heightAnchor , multiplier: 1).isActive=true
        
        chatButton.titleLabel?.font=chatButton.titleLabel?.font.withSize(self.view.frame.height * 0.03)
        
        chatButton.layer.cornerRadius = 15.0
        chatButton.clipsToBounds = true
        userContainer.addSubview(userProfileImage)
        userContainer.addSubview(chatButton)
        
        let ref = Database.database().reference().child("users").child(post!.posterId!)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]   {
                let name = dictionary["name"] as? String
                let url =  dictionary["profileImageURL"] as? String
                let email = dictionary["email"] as? String
                self.posterName.text = name
                self.posterProfileImage.loadImageUsingCacheWithUrlString(url!)
                self.emailInfo.text = email
                
                
                
                
            }
            
            
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    private func loadCurrentUserImage(userid:String)
    {
        let ref = Database.database().reference().child("users").child(userid).child("profileImageURL")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let profileUrl =  snapshot.value  as! String
            
            // Get user value
            
            self.userProfileImage.loadImageUsingCacheWithUrlString(profileUrl)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    private func setContainer()
    {
        // add views
        
        view.addSubview(NavigationContainer)
        view.addSubview(imageContainer)
        view.addSubview(posterContainer)
        view.addSubview(addressContainer)
        view.addSubview(emailContainer)
        view.addSubview(dateContainer)
        view.addSubview(timeContainer)
        view.addSubview(descriptionContainer)
        view.addSubview(userContainer)
        //
        
        //NavigationContainer
        NavigationContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.0001).isActive=true
        // same as left and right
        NavigationContainer.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive=true
        NavigationContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        NavigationContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        // image container
        imageContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.2).isActive=true
        // same as left and right
        imageContainer.topAnchor.constraint(equalTo:NavigationContainer.bottomAnchor).isActive=true
        imageContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        imageContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //poster container
        posterContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        // same as left and right
        posterContainer.topAnchor.constraint(equalTo:postTitle.bottomAnchor,constant: self.view.frame.height * 0.01).isActive=true
        posterContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        posterContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //address container
        addressContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        // same as left and right
        addressContainer.topAnchor.constraint(equalTo:posterContainer.bottomAnchor,constant: self.view.frame.height * 0.01).isActive=true
        addressContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        addressContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        // email container
        emailContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        // same as left and right
        emailContainer.topAnchor.constraint(equalTo:addressContainer.bottomAnchor,constant: self.view.frame.height * 0.01).isActive=true
        emailContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        emailContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //date container
        dateContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        // same as left and right
        dateContainer.topAnchor.constraint(equalTo:emailContainer.bottomAnchor,constant: self.view.frame.height * 0.01).isActive=true
        dateContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        dateContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //time container
        timeContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        // same as left and right
        timeContainer.topAnchor.constraint(equalTo:dateContainer.bottomAnchor,constant: self.view.frame.height * 0.01).isActive=true
        timeContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        timeContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //user
        userContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        // same as left and right
        userContainer.topAnchor.constraint(equalTo:descriptionContainer.bottomAnchor,constant: self.view.frame.height * 0.01).isActive=true
        userContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        userContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //description
        descriptionContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.1).isActive=true
        // same as left and right
        descriptionContainer.topAnchor.constraint(equalTo:descriptionLabel.bottomAnchor,constant: self.view.frame.height * 0.01).isActive=true
        descriptionContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        descriptionContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        
        
    }
    
}
