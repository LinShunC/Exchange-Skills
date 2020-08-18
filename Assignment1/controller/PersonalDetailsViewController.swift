//
//  PersonalDetailsViewController.swift
//  Assignment1
//
//  Created by linshun on 2/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class PersonalDetailsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var skillsInput: UITextField!
    @IBOutlet weak var interestsInput: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func SubmitClicked(_ sender: Any) {
        
        if ( GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            submitInformation(userid: (GIDSignIn.sharedInstance()?.currentUser.userID)!)
        }
        else if( AccessToken.current?.userID != nil)
        {
            submitInformation(userid: AccessToken.current!.userID)
        }
        else if (Auth.auth().currentUser?.uid != nil)
        {
            submitInformation(userid: Auth.auth().currentUser!.uid)
        }
        
    }
    @IBAction func popup(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpScreen") as!PopUpViewController
        self.addChild(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    // container declaration
    let topImageContainerView: UIView =
    {  let topImageContainerView = UIView()
        topImageContainerView.translatesAutoresizingMaskIntoConstraints=false
        return topImageContainerView
    }()
    
    let nameContainerView: UIView =
    {  let nameContainerView = UIView()
        nameContainerView.translatesAutoresizingMaskIntoConstraints=false
        return nameContainerView
        
        
    }()
    
    let phoneContainerView: UIView =
    {  let phoneContainerView = UIView()
        phoneContainerView.translatesAutoresizingMaskIntoConstraints=false
        return phoneContainerView
        
        
    }()
    let emailContainerView: UIView =
    {  let emailContainerView = UIView()
        emailContainerView.translatesAutoresizingMaskIntoConstraints=false
        return emailContainerView
        
        
    }()
    let skillsContainerView: UIView =
    {  let skillsContainerView = UIView()
        skillsContainerView.translatesAutoresizingMaskIntoConstraints=false
        return skillsContainerView
        
        
    }()
    let interestsContainerView: UIView =
    {  let interestsContainerView = UIView()
        interestsContainerView.translatesAutoresizingMaskIntoConstraints=false
        return interestsContainerView
        
        
    }()
    let addressContainerView: UIView =
    {  let addressContainerView = UIView()
        addressContainerView.translatesAutoresizingMaskIntoConstraints=false
        return addressContainerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //set containers
        setContainer()
        setContent()
        setNavigation()
        setInformation()
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage)))
        self.showNavigationBar()
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
    
    private func setInformation()
    {
        if ( GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            updateInformation(userid: (GIDSignIn.sharedInstance()?.currentUser.userID)!)
        }
        else if( AccessToken.current?.userID != nil)
        {
            updateInformation(userid: AccessToken.current!.userID)
        }
        else if (Auth.auth().currentUser?.uid != nil)
        {
            updateInformation(userid: Auth.auth().currentUser!.uid)
        }
    }
    private func  updateInformation(userid:String)
    {
        let ref = Database.database().reference().child("User-info").child(userid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.nameInput.text = (dictionary["name"] as! String)
                self.phoneInput.text = (dictionary["phone"] as! String)
                self.emailInput.text = (dictionary["email"] as! String)
                self.skillsInput.text = (dictionary["skill"] as! String)
                self.interestsInput.text = (dictionary["interest"] as! String)
                self.addressInput.text = (dictionary["address"] as! String)
            }
            
        }, withCancel: nil)
        let reference = Database.database().reference().child("users").child(userid)
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
                if let profileImageUrl = dictionary["profileImageURL"] as? String {
                    self.profileImage.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
            }
            
        }, withCancel: nil)
    }
    
    private func submitInformation(userid:String)
        
    {
        guard let name = nameInput.text, let phone = phoneInput.text,let email=emailInput.text,  let skill = skillsInput.text,let interest = interestsInput.text,let address = addressInput.text else
        {
            print ("Form is not valid")
            return
        }
        let values=["name":name,"phone":phone,"email":email,"skill":skill,"interest":interest,"address":address]
        
        let ref = Database.database().reference().child("User-info").child(userid)
        // let values=["name":username,"email":email,"profileImageURL":metadata.downloadUrl()]
        ref.updateChildValues(values, withCompletionBlock: {(err,ref)
            in
            if err != nil
            {
                print(err as Any)
                return
            }
            else{
              
                
            }
            
        })
        
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
                        let values=["name":name,"email":email,"profileImageURL":downloadURL.absoluteString]
                        let ref = Database.database().reference()
                        let usersReference = ref.child("users").child(userid)
                        // let values=["name":username,"email":email,"profileImageURL":metadata.downloadUrl()]
                        usersReference.updateChildValues(values, withCompletionBlock: {(err,ref)
                            in
                            if err != nil
                            {
                                print(err as Any)
                                return
                            }
                            else{
                                print("update user successfully")
                                self.performSegue(withIdentifier: "ProfileToMain", sender: self)
                                
                            }
                            
                        })
                        
                    }
                    else {
                        print(error as Any)
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                }
                
                
            })
        }
        
    }
    private func setNavigation()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
    }
    @objc private func handleBack()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
        
    }
    private func setContent()
    {
        //profile image
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        profileImage.centerYAnchor.constraint(equalTo:topImageContainerView.centerYAnchor).isActive=true
        profileImage.layer.cornerRadius = 40
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill
        // imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        
        
        profileImage.heightAnchor.constraint(equalTo:topImageContainerView.heightAnchor , multiplier: 0.5).isActive=true
        profileImage.widthAnchor.constraint(equalTo:topImageContainerView.widthAnchor , multiplier: 0.25).isActive=true
        topImageContainerView.addSubview(profileImage)
        
        //name label
        nameLabel.leadingAnchor.constraint(equalTo:nameContainerView.leadingAnchor , constant: 30).isActive=true
        nameLabel.topAnchor.constraint(equalTo:nameContainerView.topAnchor ).isActive=true
        nameLabel.bottomAnchor.constraint(equalTo:nameContainerView.bottomAnchor ).isActive=true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //name input field
        
        nameInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        nameInput.leadingAnchor.constraint(equalTo:nameLabel.trailingAnchor,constant: 40).isActive=true
        nameInput.topAnchor.constraint(equalTo:nameContainerView.topAnchor ).isActive=true
        nameInput.bottomAnchor.constraint(equalTo:nameContainerView.bottomAnchor ).isActive=true
        // border
        nameInput.layer.borderColor =  UIColor.gray.cgColor
        nameInput.layer.borderWidth = 1
        nameInput.layer.cornerRadius = 15.0
        nameInput.clipsToBounds = true
        nameInput.translatesAutoresizingMaskIntoConstraints = false
        
        nameContainerView.addSubview(nameLabel)
        nameContainerView.addSubview(nameInput)
        
        //phone label
        phoneLabel.leadingAnchor.constraint(equalTo:phoneContainerView.leadingAnchor , constant: 30).isActive=true
        phoneLabel.topAnchor.constraint(equalTo:phoneContainerView.topAnchor ).isActive=true
        phoneLabel.bottomAnchor.constraint(equalTo:phoneContainerView.bottomAnchor ).isActive=true
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //phone input field
        
        phoneInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        phoneInput.leadingAnchor.constraint(equalTo:phoneLabel.trailingAnchor,constant: 35).isActive=true
        phoneInput.topAnchor.constraint(equalTo:phoneContainerView.topAnchor ).isActive=true
        phoneInput.bottomAnchor.constraint(equalTo:phoneContainerView.bottomAnchor ).isActive=true
        // border
        phoneInput.layer.borderColor =  UIColor.gray.cgColor
        phoneInput.layer.borderWidth = 1
        
        phoneInput.layer.cornerRadius = 15.0
        phoneInput.clipsToBounds = true
        phoneInput.translatesAutoresizingMaskIntoConstraints = false
        
        phoneContainerView.addSubview(phoneLabel)
        phoneContainerView.addSubview(phoneInput)
        
        
        //email label
        emailLabel.leadingAnchor.constraint(equalTo:emailContainerView.leadingAnchor , constant: 30).isActive=true
        emailLabel.topAnchor.constraint(equalTo:emailContainerView.topAnchor ).isActive=true
        emailLabel.bottomAnchor.constraint(equalTo:emailContainerView.bottomAnchor ).isActive=true
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //email input field
        
        emailInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        emailInput.leadingAnchor.constraint(equalTo:emailLabel.trailingAnchor,constant: 42).isActive=true
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
        
        //skill label
        skillsLabel.leadingAnchor.constraint(equalTo:skillsContainerView.leadingAnchor , constant: 30).isActive=true
        skillsLabel.topAnchor.constraint(equalTo:skillsContainerView.topAnchor ).isActive=true
        skillsLabel.bottomAnchor.constraint(equalTo:skillsContainerView.bottomAnchor ).isActive=true
        skillsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //skill input field
        
        skillsInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        skillsInput.leadingAnchor.constraint(equalTo:skillsLabel.trailingAnchor,constant: 42).isActive=true
        skillsInput.topAnchor.constraint(equalTo:skillsContainerView.topAnchor ).isActive=true
        skillsInput.bottomAnchor.constraint(equalTo:skillsContainerView.bottomAnchor ).isActive=true
        // border
        skillsInput.layer.borderColor =  UIColor.gray.cgColor
        skillsInput.layer.borderWidth = 1
        
        skillsInput.layer.cornerRadius = 15.0
        skillsInput.clipsToBounds = true
        skillsInput.translatesAutoresizingMaskIntoConstraints = false
        
        skillsContainerView.addSubview(skillsLabel)
        skillsContainerView.addSubview(skillsInput)
        //interests label
        interestsLabel.leadingAnchor.constraint(equalTo:interestsContainerView.leadingAnchor , constant: 30).isActive=true
        interestsLabel.topAnchor.constraint(equalTo:interestsContainerView.topAnchor ).isActive=true
        interestsLabel.bottomAnchor.constraint(equalTo:interestsContainerView.bottomAnchor ).isActive=true
        interestsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //interests input field
        
        interestsInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        interestsInput.leadingAnchor.constraint(equalTo:interestsLabel.trailingAnchor,constant: 18).isActive=true
        interestsInput.topAnchor.constraint(equalTo:interestsContainerView.topAnchor ).isActive=true
        interestsInput.bottomAnchor.constraint(equalTo:interestsContainerView.bottomAnchor ).isActive=true
        // border
        interestsInput.layer.borderColor =  UIColor.gray.cgColor
        interestsInput.layer.borderWidth = 1
        
        interestsInput.layer.cornerRadius = 15.0
        interestsInput.clipsToBounds = true
        interestsInput.translatesAutoresizingMaskIntoConstraints = false
        
        interestsContainerView.addSubview(interestsLabel)
        interestsContainerView.addSubview(interestsInput)
        
        //address label
        addressLabel.leadingAnchor.constraint(equalTo:addressContainerView.leadingAnchor , constant: 30).isActive=true
        addressLabel.topAnchor.constraint(equalTo:addressContainerView.topAnchor ).isActive=true
        addressLabel.bottomAnchor.constraint(equalTo:addressContainerView.bottomAnchor ).isActive=true
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //interests input field
        
        addressInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        addressInput.leadingAnchor.constraint(equalTo:addressLabel.trailingAnchor,constant: 20).isActive=true
        addressInput.topAnchor.constraint(equalTo:addressContainerView.topAnchor ).isActive=true
        addressInput.bottomAnchor.constraint(equalTo:addressContainerView.bottomAnchor ).isActive=true
        // border
        addressInput.layer.borderColor =  UIColor.gray.cgColor
        addressInput.layer.borderWidth = 1
        
        addressInput.layer.cornerRadius = 15.0
        addressInput.clipsToBounds = true
        addressInput.translatesAutoresizingMaskIntoConstraints = false
        
        addressContainerView.addSubview(addressLabel)
        addressContainerView.addSubview(addressInput)
        // submit button
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        submitButton.topAnchor.constraint(equalTo: addressContainerView.bottomAnchor, constant: self.view.frame.height * 0.05).isActive=true
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive=true
        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive=true
        //button elements
        submitButton.titleLabel?.font=submitButton.titleLabel?.font.withSize(self.view.frame.height * 0.03)
        submitButton.layer.cornerRadius = 15.0
        submitButton.clipsToBounds = true
        
    }
    private func setContainer()
    {
        //add views
        view.addSubview(topImageContainerView)
        view.addSubview(nameContainerView)
        view.addSubview(phoneContainerView)
        view.addSubview(emailContainerView)
        view.addSubview(skillsContainerView)
        view.addSubview(interestsContainerView)
        view.addSubview(addressContainerView)
        
        topImageContainerView.topAnchor.constraint(equalTo:view.topAnchor,constant: view.frame.height * 0.06 ).isActive=true
        
        // topImageContainerView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive=true
        
        //topImageContainerView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive=true
        
        topImageContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.2).isActive=true
        
        // same as left and right
        topImageContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        topImageContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        // name container
        
        // username container
        nameContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        nameContainerView.topAnchor.constraint(equalTo:profileImage.bottomAnchor,constant: self.view.frame.height * 0.03).isActive=true
        
        nameContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        nameContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        //phone container
        
        phoneContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        phoneContainerView.topAnchor.constraint(equalTo:nameContainerView.bottomAnchor,constant: self.view.frame.height * 0.03).isActive=true
        
        phoneContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        phoneContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //email container
        emailContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        emailContainerView.topAnchor.constraint(equalTo:phoneContainerView.bottomAnchor,constant: self.view.frame.height * 0.03).isActive=true
        
        emailContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        emailContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //email container
        skillsContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        skillsContainerView.topAnchor.constraint(equalTo:emailContainerView.bottomAnchor,constant: self.view.frame.height * 0.03).isActive=true
        
        skillsContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        skillsContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //interest container
        interestsContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        interestsContainerView.topAnchor.constraint(equalTo:skillsContainerView.bottomAnchor,constant: self.view.frame.height * 0.03).isActive=true
        
        interestsContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        interestsContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
        //address container
        addressContainerView.heightAnchor.constraint(equalTo:view.heightAnchor , multiplier: 0.05).isActive=true
        addressContainerView.topAnchor.constraint(equalTo:interestsContainerView.bottomAnchor,constant: self.view.frame.height * 0.03).isActive=true
        
        addressContainerView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        addressContainerView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        
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
