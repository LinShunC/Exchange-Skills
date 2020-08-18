//
//  RegisterViewController.swift
//  Assignment1
//
//  Created by linshun on 1/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class RegisterViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var applicationName: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var confirmInput: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // container declaration
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
    let emailContainerView: UIView =
    {  let emailContainerView = UIView()
        emailContainerView.translatesAutoresizingMaskIntoConstraints=false
        return emailContainerView
        
        
    }()
    
    let passwordContainerView: UIView =
    {  let passwordContainerView = UIView()
        passwordContainerView.translatesAutoresizingMaskIntoConstraints=false
        return passwordContainerView
        
        
    }()
    
    let confirmContainerView: UIView =
    {  let confirmContainerView = UIView()
        confirmContainerView.translatesAutoresizingMaskIntoConstraints=false
        return confirmContainerView
        
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topImageContainerView)
        view.addSubview(usernameContainerView)
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(confirmContainerView)
        // Do any additional setup after loading the view.
        setTopView()
        setContainer()
        setInformation()
        setButtons()
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage)))
    }
    @objc private func handleSelectProfileImage()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info [UIImagePickerController.InfoKey.editedImage]as?UIImage
        {
          
            selectedImageFromPicker = editedImage
        }
        else  if let originalImage = info[UIImagePickerController.InfoKey.originalImage]as? UIImage
        {
            print(originalImage.size)
            selectedImageFromPicker = originalImage
        }
        if let selectedImage =  selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
    private func setButtons()
    {
        // register button
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.06).isActive=true
        registerButton.topAnchor.constraint(equalTo: confirmContainerView.bottomAnchor, constant: self.view.frame.height * 0.04).isActive=true
        registerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive=true
        registerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        //button elements
        registerButton.titleLabel?.font=registerButton.titleLabel?.font.withSize(self.view.frame.height * 0.03)
        registerButton.layer.cornerRadius = 15.0
        registerButton.clipsToBounds = true
        registerButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        //login button
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.06).isActive=true
        loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: self.view.frame.height * 0.04).isActive=true
        loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive=true
        loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        loginButton.titleLabel?.font=loginButton.titleLabel?.font.withSize(self.view.frame.height * 0.03)
        
        loginButton.layer.cornerRadius = 15.0
        loginButton.clipsToBounds = true
        
    }
    private func setInformation()
    {
        // username label
        usernameLabel.leadingAnchor.constraint(equalTo:usernameContainerView.leadingAnchor , constant: 30).isActive=true
        usernameLabel.topAnchor.constraint(equalTo:usernameContainerView.topAnchor ).isActive=true
        usernameLabel.bottomAnchor.constraint(equalTo:usernameContainerView.bottomAnchor ).isActive=true
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //username input field
        
        usernameInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        usernameInput.leadingAnchor.constraint(equalTo:usernameLabel.trailingAnchor,constant: 30).isActive=true
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
        
        
        // email label
        emailLabel.leadingAnchor.constraint(equalTo:emailContainerView.leadingAnchor , constant: 30).isActive=true
        emailLabel.topAnchor.constraint(equalTo:emailContainerView.topAnchor ).isActive=true
        emailLabel.bottomAnchor.constraint(equalTo:emailContainerView.bottomAnchor ).isActive=true
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //email input field
        
        emailInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        emailInput.leadingAnchor.constraint(equalTo:emailLabel.trailingAnchor,constant: 65).isActive=true
        emailInput.topAnchor.constraint(equalTo:emailContainerView.topAnchor ).isActive=true
        emailInput.bottomAnchor.constraint(equalTo:emailContainerView.bottomAnchor ).isActive=true
        // border
        emailInput.layer.borderColor =  UIColor.gray.cgColor
        emailInput.layer.borderWidth = 1
        emailInput.layer.cornerRadius = 15.0
        emailInput.clipsToBounds = true
        emailInput.translatesAutoresizingMaskIntoConstraints = false
        
        emailContainerView.addSubview(emailLabel)
        emailContainerView.addSubview(emailInput)
        
        // password label
        passwordLabel.leadingAnchor.constraint(equalTo:passwordContainerView.leadingAnchor , constant: 30).isActive=true
        passwordLabel.topAnchor.constraint(equalTo:passwordContainerView.topAnchor ).isActive=true
        passwordLabel.bottomAnchor.constraint(equalTo:passwordContainerView.bottomAnchor ).isActive=true
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //password input field
        
        passwordInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        passwordInput.leadingAnchor.constraint(equalTo:passwordLabel.trailingAnchor,constant: 35).isActive=true
        passwordInput.topAnchor.constraint(equalTo:passwordContainerView.topAnchor ).isActive=true
        passwordInput.bottomAnchor.constraint(equalTo:passwordContainerView.bottomAnchor ).isActive=true
        // border
        passwordInput.layer.borderColor =  UIColor.gray.cgColor
        passwordInput.layer.borderWidth = 1
        passwordInput.layer.cornerRadius = 15.0
        passwordInput.clipsToBounds = true
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        
        passwordInput.isSecureTextEntry = true
        passwordContainerView.addSubview(passwordLabel)
        passwordContainerView.addSubview(passwordInput)
        
        // confirm label
        confirmLabel.leadingAnchor.constraint(equalTo:confirmContainerView.leadingAnchor , constant: 30).isActive=true
        confirmLabel.topAnchor.constraint(equalTo:confirmContainerView.topAnchor ).isActive=true
        confirmLabel.bottomAnchor.constraint(equalTo:confirmContainerView.bottomAnchor ).isActive=true
        confirmLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        //confirm input field
        confirmInput.translatesAutoresizingMaskIntoConstraints = false
        confirmInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        confirmInput.leadingAnchor.constraint(equalTo:confirmLabel.trailingAnchor,constant: 35).isActive=true
        confirmInput.topAnchor.constraint(equalTo:confirmContainerView.topAnchor ).isActive=true
        confirmInput.bottomAnchor.constraint(equalTo:confirmContainerView.bottomAnchor ).isActive=true
        // border
        confirmInput.layer.borderColor =  UIColor.gray.cgColor
        confirmInput.layer.borderWidth = 1
        confirmInput.layer.cornerRadius = 15.0
        confirmInput.clipsToBounds = true
        confirmInput.isEnabled = true
        confirmInput.isSecureTextEntry = true
        
        
        
        confirmContainerView.addSubview(confirmLabel)
        confirmContainerView.addSubview(confirmInput)
        
    }
    
    private func setContainer()
    {
        
        topImageContainerView.topAnchor.constraint(equalTo:view.topAnchor).isActive=true
        
        // topImageContainerView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive=true
        
        //topImageContainerView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive=true
        
        topImageContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.4).isActive=true
        
        // same as left and right
        topImageContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        topImageContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        // username container
        usernameContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        usernameContainerView.topAnchor.constraint(equalTo:profileImage.bottomAnchor,constant: self.view.frame.height * 0.03).isActive=true
        
        usernameContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        usernameContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        // email container
        emailContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        emailContainerView.topAnchor.constraint(equalTo:usernameContainerView.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        
        emailContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        emailContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //password container
        
        passwordContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        passwordContainerView.topAnchor.constraint(equalTo:emailContainerView.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        
        passwordContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        passwordContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //password container
        
        confirmContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        confirmContainerView.topAnchor.constraint(equalTo:passwordContainerView.bottomAnchor,constant: self.view.frame.height * 0.02).isActive=true
        
        confirmContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        confirmContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        
    }
    private func setTopView()
    {
        // application name
        applicationName.font = applicationName.font.withSize(self.view.frame.height * 0.03)
        applicationName.translatesAutoresizingMaskIntoConstraints = false
        applicationName.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive=true
        applicationName.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,constant: 5).isActive=true
        //profile image
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        profileImage.centerYAnchor.constraint(equalTo:topImageContainerView.centerYAnchor).isActive=true
        // imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        
        
        profileImage.heightAnchor.constraint(equalTo:topImageContainerView.heightAnchor , multiplier: 0.5).isActive=true
        topImageContainerView.addSubview(profileImage)
        
    }
    @objc func handleRegister()
        
    {
        
        guard let email = emailInput.text, let password = passwordInput.text,let username=usernameInput.text else
        {
            print ("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil
            {
                print(error as Any)
                return
            }
            
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_image").child("\(imageName).jpg")
            
            
            if let uploadData = self.profileImage.image!.jpegData(compressionQuality: 0.06){
                // if let uploadData = self.profileImage.image!.pngData()
                //{
                storageRef.putData(uploadData, metadata: nil,completion:  { (metadata, error) in
                    if error != nil
                    {
                        print(error as Any)
                        
                        return
                    }
                    storageRef.downloadURL { (url, error) in
                        if let downloadURL = url
                        {
                            let values=["name":username,"email":email,"profileImageURL":downloadURL.absoluteString]
                            self.registerUserIntoDatabase(values: values as [String : AnyObject])
                        }
                        else {
                            print(error as Any)
                            // Uh-oh, an error occurred!
                            return
                        }}
                    
                    
                })
            }
        }
    }
    
    private func registerUserIntoDatabase(values:[String:AnyObject])
    {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(Auth.auth().currentUser!.uid)
        // let values=["name":username,"email":email,"profileImageURL":metadata.downloadUrl()]
        usersReference.updateChildValues(values, withCompletionBlock: {(err,ref)
            in
            if err != nil
            {
                print(err as Any)
                return
            }
            else{
                print("created user successfully")
                self.performSegue(withIdentifier: "toLogin", sender: self)
            }
            
        })
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
