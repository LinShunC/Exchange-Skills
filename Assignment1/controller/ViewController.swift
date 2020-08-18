//
//  ViewController.swift
//  Assignment1
//
//  Created by linshun on 31/12/19.
//  Copyright © 2019 Shunyang Dong. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController,GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        /*  */
        // ...
        if error != nil {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                return
            }
            // User is signed in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
            let navigationControlr = UINavigationController(rootViewController: vc)
            // vc.modalPresentationStyle = .fullScreen
            navigationControlr.modalPresentationStyle = .fullScreen
            self.present(navigationControlr, animated: true, completion: nil)
            // ...
        }
        
        
        
    }
    
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var applicationName: UILabel!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var googleSign: GIDSignInButton!
    @IBOutlet weak var facebookSign: FBLoginButton!
    @IBOutlet weak var Slogan: UILabel!
    @IBAction func FacebookLogin(_ sender: Any) {
        
        
        
        
        
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions:["public_profile","email"],
            from: self
        ) { (result,error) in
            if error != nil
            {
                print(error)
            }
            else{
                self.FacebookToFirebase()
                
                
            }
        }
        
    }
    
    let topImageContainerView: UIView =
    {  let topImageContainerView = UIView()
        topImageContainerView.translatesAutoresizingMaskIntoConstraints=false
        return topImageContainerView
        
        
        
    }()
    let usernameContainerView: UIView =
    {  let usernameContainerView = UIView()
        usernameContainerView.translatesAutoresizingMaskIntoConstraints=false
        return usernameContainerView
        
        
    }()
    let passwordContainerView: UIView =
    {  let passwordContainerView = UIView()
        passwordContainerView.translatesAutoresizingMaskIntoConstraints=false
        return passwordContainerView
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topImageContainerView)
        view.addSubview(usernameContainerView)
        view.addSubview(passwordContainerView)
        self.HideKeyBoard()
        
        
        setupContainer()
        setLogo()
        setLogin()
        setButtons()
        //        checkLoginStatus()
        self.hideNavigationBar()
        
        // Do any additional setup after loading the view.
        // Add FBLoginButton at center of view controller
        
        
        
        
    }
    private func checkLoginStatus()
    {
        
        if Auth.auth().currentUser != nil  || GIDSignIn.sharedInstance()?.currentUser != nil || AccessToken.current != nil {
            
            
            let mainController = MainViewController()
            present(mainController,animated: true,completion: {})
            
        }
        else {
            
            print("please login")
            
        }
    }
    
    private func setButtons(){
        //login button
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.06).isActive=true
        loginButton.topAnchor.constraint(equalTo: passwordContainerView.bottomAnchor, constant: self.view.frame.height * 0.022).isActive=true
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive=true
        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        
        loginButton.layer.cornerRadius = 15.0
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        loginButton.clipsToBounds = true
        
        // register button
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.06).isActive=true
        registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: self.view.frame.height * 0.022).isActive=true
        registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive=true
        registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        
        registerButton.layer.cornerRadius = 15.0
        registerButton.clipsToBounds = true
        
        // google sign in
        googleSign.translatesAutoresizingMaskIntoConstraints = false
        //  let testGoogleLogin = GIDSignInButton()
        
        
        
        
        
        googleSign.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.06).isActive=true
        googleSign.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: self.view.frame.height * 0.022).isActive=true
        googleSign.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive=true
        googleSign.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        
        googleSign.layer.cornerRadius = 15.0
        googleSign.clipsToBounds = true
        
        googleSign.addTarget(self, action: #selector(handleGoogleSign), for: .touchUpInside)
        
        
        //facebook sign in
        facebookSign.translatesAutoresizingMaskIntoConstraints = false
        facebookSign.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.06).isActive=true
        facebookSign.topAnchor.constraint(equalTo: googleSign.bottomAnchor, constant: self.view.frame.height * 0.022).isActive=true
        facebookSign.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive=true
        facebookSign.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        facebookSign.layer.cornerRadius = 15.0
        facebookSign.clipsToBounds = true
        //         / facebookSign.addTarget(self, action: #selector(handleFacebookSign), for: .touchUpInside)
        
        
        
    }
    private func setLogin()
    {
        // username label
        usernameLabel.leadingAnchor.constraint(equalTo:usernameContainerView.leadingAnchor , constant: 30).isActive=true
        usernameLabel.topAnchor.constraint(equalTo:usernameContainerView.topAnchor ).isActive=true
        usernameLabel.bottomAnchor.constraint(equalTo:usernameContainerView.bottomAnchor ).isActive=true
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //username input field
        
        usernameInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        usernameInput.leadingAnchor.constraint(equalTo:passwordInput.leadingAnchor).isActive=true
        usernameInput.topAnchor.constraint(equalTo:usernameContainerView.topAnchor ).isActive=true
        usernameInput.bottomAnchor.constraint(equalTo:usernameContainerView.bottomAnchor ).isActive=true
        // border
        usernameInput.layer.borderColor =  UIColor.gray.cgColor
        usernameInput.layer.borderWidth = 1
        usernameInput.layer.cornerRadius = 15.0
        usernameInput.clipsToBounds = true
        usernameInput.translatesAutoresizingMaskIntoConstraints = false
        
        usernameContainerView.addSubview(usernameLabel)
        usernameContainerView.addSubview(usernameInput)
        
        // password label
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.leadingAnchor.constraint(equalTo:passwordContainerView.leadingAnchor , constant: 30).isActive=true
        passwordLabel.topAnchor.constraint(equalTo:passwordContainerView.topAnchor ).isActive=true
        passwordLabel.bottomAnchor.constraint(equalTo:passwordContainerView.bottomAnchor ).isActive=true
        
        
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        
        passwordInput.leadingAnchor.constraint(equalTo: passwordLabel.trailingAnchor , constant: 33).isActive=true
        passwordInput.topAnchor.constraint(equalTo:passwordContainerView.topAnchor ).isActive=true
        passwordInput.bottomAnchor.constraint(equalTo:passwordContainerView.bottomAnchor ).isActive=true
        passwordInput.trailingAnchor.constraint(equalTo:passwordContainerView.trailingAnchor, constant: -33).isActive=true
        passwordInput.isSecureTextEntry = true
        // border
        passwordInput.layer.borderColor =  UIColor.gray.cgColor
        passwordInput.layer.borderWidth = 1
        passwordInput.layer.cornerRadius = 15.0
        passwordInput.clipsToBounds = true
        
        
        
        passwordContainerView.addSubview(passwordLabel)
        passwordContainerView.addSubview(passwordInput)
        
        
        
    }
    
    private func setLogo()
    {
        // application name
        // applicationName.font = applicationName.font.withSize(self.view.frame.height * 0.04)
        applicationName.translatesAutoresizingMaskIntoConstraints = false
        applicationName.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        applicationName.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive=true
        
        
        
        
        
        // logo
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive=true
        logo.topAnchor.constraint(equalTo:applicationName.bottomAnchor,constant: self.view.frame.height * 0.04).isActive=true
        logo.heightAnchor.constraint(equalTo:topImageContainerView.heightAnchor , multiplier: 0.5).isActive=true
        //   logo.image = UIImage(named: "home")
        // imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        
        
        
        
        topImageContainerView.addSubview(logo)
        
        topImageContainerView.addSubview(applicationName)
    }
    private func setupContainer()
    {
        // top container
        
        //  topImageContainerView.frame=CGRect(x:0,y:0,width:100,height:100)
        
        
        topImageContainerView.topAnchor.constraint(equalTo:view.topAnchor,constant: self.view.frame.height * 0.02).isActive=true
        
        // topImageContainerView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive=true
        
        //topImageContainerView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive=true
        
        topImageContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.5).isActive=true
        
        // same as left and right
        topImageContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        topImageContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        // username container
        usernameContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        usernameContainerView.topAnchor.constraint(equalTo:logo.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        
        usernameContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        usernameContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        // password container
        
        passwordContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        passwordContainerView.topAnchor.constraint(equalTo:usernameContainerView.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        
        passwordContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        passwordContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        
    }
    @objc func handleGoogleSign()
    {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        GIDSignIn.sharedInstance().signIn()
        
        /* check for user's token */
        //performSegue(withIdentifier: "toMaintest", sender: self)
        
        //           let email =  GIDSignIn.sharedInstance().currentUser.profile.email
        
        
    }
    
    @objc func handleLogin()
    {
        guard let email = usernameInput.text, let password = passwordInput.text,let username=usernameInput.text
            else
        {
            print ("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: {(
            user,error) in
            if error != nil
            {
                print(error as Any)
            }
            else{
                
                self.performSegue(withIdentifier: "toMaintest", sender: self)
            }
        }
        )
        
    }
    
    
    func FacebookToFirebase()
    {
        
        guard let authticationToken =  AccessToken.current?.tokenString else{return}
        let credential = FacebookAuthProvider.credential(withAccessToken: authticationToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                print(error)
                
                
                return
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
            let navigationControlr = UINavigationController(rootViewController: vc)
            
            navigationControlr.modalPresentationStyle = .fullScreen
            
            self.present(navigationControlr, animated: true, completion: nil)
            
        }
    }
    
}

