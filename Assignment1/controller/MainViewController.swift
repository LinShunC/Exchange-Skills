//
//  MainViewController.swift
//  Assignment1
//
//  Created by linshun on 1/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import  GoogleSignIn

extension UIViewController {
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var fLogo: UIImageView!
    @IBOutlet weak var fButton: UIButton!
    @IBOutlet weak var sLogo: UIImageView!
    @IBOutlet weak var sButton: UIButton!
    @IBOutlet weak var tLogo: UIImageView!
    @IBOutlet weak var tButton: UIButton!
    @IBOutlet weak var lLogo: UIImageView!
    @IBOutlet weak var lButton: UIButton!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var narBar: UINavigationItem!
    @IBOutlet weak var popupButton: UIButton!
    
    
    @IBAction func Logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            performSegue(withIdentifier: "MainToLogin", sender: self)
            let loginManager = LoginManager()
            loginManager.logOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    @IBAction func popup(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpScreen") as!PopUpViewController
        self.addChild(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
        
    }
    
    @IBOutlet weak var emailPopup: UIImageView!
    
    let fContainer: UIView =
    {  let fContainer = UIView()
        fContainer.translatesAutoresizingMaskIntoConstraints=false
        return fContainer
        
        
    }()
    let sContainer: UIView =
    {  let sContainer = UIView()
        sContainer.translatesAutoresizingMaskIntoConstraints=false
        return sContainer
        
        
    }()
    let tContainer: UIView =
    {  let tContainer = UIView()
        tContainer.translatesAutoresizingMaskIntoConstraints=false
        return tContainer
        
        
    }()
    let lContainer: UIView =
    {  let lContainer = UIView()
        lContainer.translatesAutoresizingMaskIntoConstraints=false
        return lContainer
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(fContainer)
        view.addSubview(sContainer)
        view.addSubview(tContainer)
        view.addSubview(lContainer)
        
        
        self.showNavigationBar()
        setContainer()
        setButtons()
        checkLogin()
        updateGoogleUser()
        updateFacebook()
        
        emailPopup.isUserInteractionEnabled = true
        emailPopup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        
        /*user.userID
         // For client-side use only!
         let idToken = GIDSignIn.sharedInstance()?.currentUser.authentication.idToken // Safe to send to the server
         let fullName = GIDSignIn.sharedInstance()?.currentUser.profile.name
         let givenName = GIDSignIn.sharedInstance()?.currentUser.profile.givenName
         let familyName = GIDSignIn.sharedInstance()?.currentUser.profile.familyName
         let email = GIDSignIn.sharedInstance()?.currentUser.profile.email*/
        
        
    }
    private func updateGoogleUser()
    {
        if(GIDSignIn.sharedInstance()?.currentUser != nil){
            let ref = Database.database().reference(fromURL: "https://ios-exchangeskill-app.firebaseio.com/")
            let usersReference = ref.child("users").child((GIDSignIn.sharedInstance()?.currentUser.userID)!)
            let values=["name":GIDSignIn.sharedInstance()?.currentUser.profile.name,"email":GIDSignIn.sharedInstance()?.currentUser.profile.email,"profileImageURL":GIDSignIn.sharedInstance()?.currentUser.profile.imageURL(withDimension: 100)?.absoluteString]
            
            usersReference.updateChildValues(values, withCompletionBlock: {(err,ref)
                in
                if err != nil
                {
                    print(err as Any)
                    return
                }
               
                
            })
        }
        
        
    }
    private func updateFacebook(){
        if(AccessToken.current?.tokenString != nil)
        {
            let ref = Database.database().reference(fromURL: "https://ios-exchangeskill-app.firebaseio.com/")
            let usersReference = ref.child("users").child(AccessToken.current!.userID)
            
            let r = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.type(large)"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: HTTPMethod(rawValue: "GET"))
            
            r.start(completionHandler: { (test, result, error) in
                if(error == nil)
                {
                    guard let Info = result as? [String: Any] else { return }
                    
                    if let imageURL = ((Info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                        
                        let url = URL(string: imageURL)?.absoluteString
                        
                        let values = ["name":Info["name"],"email":Info["email"],"profileImageURL":url]
                        usersReference.updateChildValues(values as [AnyHashable : Any], withCompletionBlock: {(err,ref)
                            in
                            if err != nil
                            {
                                print(err as Any)
                                return
                            }
                         
                            
                        })
                        
                    }
                    
                }
            })
            
        }
    }
    private func checkLogin()
    {  if Auth.auth().currentUser?.uid == nil && GIDSignIn.sharedInstance()?.currentUser == nil && AccessToken.current?.tokenString == nil
    {
        performSegue(withIdentifier: "MainToLogin", sender: self)
    }
 
        
    }
    
    private func setButtons()
    {
        // first logo
        fLogo.translatesAutoresizingMaskIntoConstraints = false
        
        fLogo.topAnchor.constraint(equalTo: fContainer.topAnchor).isActive=true
        fLogo.bottomAnchor.constraint(equalTo: fContainer.bottomAnchor).isActive=true
        fLogo.leadingAnchor.constraint(equalTo: fContainer.leadingAnchor,constant: 30).isActive=true
        fLogo.heightAnchor.constraint(equalTo:fContainer.heightAnchor , multiplier:1).isActive=true
        
        // first button
        fButton.translatesAutoresizingMaskIntoConstraints = false
        fButton.leadingAnchor.constraint(equalTo: fLogo.trailingAnchor,constant: 30).isActive=true
        fButton.trailingAnchor.constraint(equalTo: fContainer.trailingAnchor,constant: -30).isActive=true
        
        
        fButton.topAnchor.constraint(equalTo: fContainer.topAnchor).isActive=true
        fButton.bottomAnchor.constraint(equalTo: fContainer.bottomAnchor).isActive=true
        //fButton.titleLabel?.font=fButton.titleLabel?.font.withSize(self.view.frame.height * 0.03)
        
        fButton.layer.cornerRadius = 15.0
        fButton.clipsToBounds = true
        
        fContainer.addSubview(fLogo)
        fContainer.addSubview(fButton)
        
        //second logo
        sLogo.translatesAutoresizingMaskIntoConstraints = false
        
        sLogo.topAnchor.constraint(equalTo: sContainer.topAnchor).isActive=true
        sLogo.bottomAnchor.constraint(equalTo: sContainer.bottomAnchor).isActive=true
        sLogo.leadingAnchor.constraint(equalTo: sContainer.leadingAnchor,constant: 30).isActive=true
        sLogo.heightAnchor.constraint(equalTo:sContainer.heightAnchor , multiplier:1).isActive=true
        
        // second button
        sButton.translatesAutoresizingMaskIntoConstraints = false
        sButton.leadingAnchor.constraint(equalTo: sLogo.trailingAnchor,constant: 30).isActive=true
        sButton.trailingAnchor.constraint(equalTo: sContainer.trailingAnchor,constant: -30).isActive=true
        
        
        sButton.topAnchor.constraint(equalTo: sContainer.topAnchor).isActive=true
        sButton.bottomAnchor.constraint(equalTo: sContainer.bottomAnchor).isActive=true
        
        
        sButton.layer.cornerRadius = 15.0
        sButton.clipsToBounds = true
        
        sContainer.addSubview(sLogo)
        sContainer.addSubview(sButton)
        
        //third logo
        tLogo.translatesAutoresizingMaskIntoConstraints = false
        
        tLogo.topAnchor.constraint(equalTo: tContainer.topAnchor).isActive=true
        tLogo.bottomAnchor.constraint(equalTo: tContainer.bottomAnchor).isActive=true
        tLogo.leadingAnchor.constraint(equalTo: tContainer.leadingAnchor,constant: 30).isActive=true
        tLogo.heightAnchor.constraint(equalTo:tContainer.heightAnchor , multiplier:1).isActive=true
        
        // third button
        tButton.translatesAutoresizingMaskIntoConstraints = false
        tButton.leadingAnchor.constraint(equalTo: tLogo.trailingAnchor,constant: 30).isActive=true
        tButton.trailingAnchor.constraint(equalTo: tContainer.trailingAnchor,constant: -30).isActive=true
        
        
        tButton.topAnchor.constraint(equalTo: tContainer.topAnchor).isActive=true
        tButton.bottomAnchor.constraint(equalTo: tContainer.bottomAnchor).isActive=true
        
        tButton.layer.cornerRadius = 15.0
        tButton.clipsToBounds = true
        
        tContainer.addSubview(tLogo)
        tContainer.addSubview(tButton)
        
        //last logo
        lLogo.translatesAutoresizingMaskIntoConstraints = false
        
        lLogo.topAnchor.constraint(equalTo: lContainer.topAnchor).isActive=true
        lLogo.bottomAnchor.constraint(equalTo: lContainer.bottomAnchor).isActive=true
        lLogo.leadingAnchor.constraint(equalTo: lContainer.leadingAnchor,constant: 30).isActive=true
        lLogo.heightAnchor.constraint(equalTo:lContainer.heightAnchor , multiplier:1).isActive=true
        
        // last button
        lButton.translatesAutoresizingMaskIntoConstraints = false
        lButton.leadingAnchor.constraint(equalTo: lLogo.trailingAnchor,constant: 30).isActive=true
        lButton.trailingAnchor.constraint(equalTo: lContainer.trailingAnchor,constant: -30).isActive=true
        
        
        lButton.topAnchor.constraint(equalTo: lContainer.topAnchor).isActive=true
        lButton.bottomAnchor.constraint(equalTo: lContainer.bottomAnchor).isActive=true
        
        
        lButton.layer.cornerRadius = 15.0
        lButton.clipsToBounds = true
        
        lContainer.addSubview(lLogo)
        lContainer.addSubview(lButton)
        emailImage.translatesAutoresizingMaskIntoConstraints = false
        emailImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,constant:-10).isActive=true
        emailImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10).isActive=true
        
        emailImage.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier:0.1).isActive=true
        
        
    }
    private func setContainer()
    {
        
        // first container
        fContainer.topAnchor.constraint(equalTo:view.topAnchor,constant: view.frame.height * 0.12).isActive=true
        fContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.1).isActive=true
        // same as left and right
        fContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        fContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //second container
        sContainer.topAnchor.constraint(equalTo:fContainer.bottomAnchor,constant: view.frame.height * 0.05).isActive=true
        sContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.1).isActive=true
        // same as left and right
        sContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        sContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //third container
        tContainer.topAnchor.constraint(equalTo:sContainer.bottomAnchor,constant: view.frame.height * 0.05).isActive=true
        tContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.1).isActive=true
        // same as left and right
        tContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        tContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        
        //last container
        lContainer.topAnchor.constraint(equalTo:tContainer.bottomAnchor,constant: view.frame.height * 0.05).isActive=true
        lContainer.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.1).isActive=true
        // same as left and right
        lContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        lContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //   popupButton.translatesAutoresizingMaskIntoConstraints=false
        
        //  popupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
        // popupButton.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        
    }
    @objc func imageTap() {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "postPupup") as!postPopupViewController
        self.addChild(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */   override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
}
