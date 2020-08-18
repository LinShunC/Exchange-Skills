//
//  postPopupViewController.swift
//  Assignment1
//
//  Created by linshun on 8/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class postPopupViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var addressInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextField!
    @IBOutlet weak var ActivityTimeInput: UITextField!
    @IBOutlet weak var ActivityDateInput: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancel: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        // Do any additional setup after loading the view.
        self.view.backgroundColor=UIColor.black.withAlphaComponent(0.8)
        setContainer()
        setContent()
        showAnimate()
        view.addSubview(popupView)
        postImage.isUserInteractionEnabled = true
        postImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handlePost)))
        activityImage.isUserInteractionEnabled = true
        activityImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleSelectProfileImage)))
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
            activityImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
   
        dismiss(animated: true, completion: nil)
    }
    private func setContainer()
    {
        
        
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        popupView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        popupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive=true
        popupView.bottomAnchor.constraint(equalTo: postImage.bottomAnchor).isActive=true
        
        
        popupView.backgroundColor=UIColor.black.withAlphaComponent(0)
    }
    private func setContent()
    {
        //title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo:popupView.leadingAnchor).isActive=true
        titleLabel.trailingAnchor.constraint(equalTo:profileImage.leadingAnchor).isActive=true
        titleLabel.topAnchor.constraint(equalTo:popupView.topAnchor).isActive=true
        
        titleLabel.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.07).isActive=true
        
        //title label
        addressInput.translatesAutoresizingMaskIntoConstraints = false
        addressInput.leadingAnchor.constraint(equalTo:popupView.leadingAnchor).isActive=true
        addressInput.trailingAnchor.constraint(equalTo:profileImage.leadingAnchor).isActive=true
        addressInput.topAnchor.constraint(equalTo:titleLabel.bottomAnchor).isActive=true
        addressInput.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.07).isActive=true
        
        // profile image
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.trailingAnchor.constraint(equalTo:popupView.trailingAnchor).isActive=true
        profileImage.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.14).isActive = true
        profileImage.widthAnchor.constraint(equalTo: popupView.widthAnchor, multiplier: 0.2).isActive = true
        profileImage.topAnchor.constraint(equalTo:popupView.topAnchor).isActive=true
        
        
        
        
        
        
        // description Input
        descriptionInput.translatesAutoresizingMaskIntoConstraints = false
        descriptionInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        descriptionInput.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        descriptionInput.topAnchor.constraint(equalTo:profileImage.bottomAnchor).isActive=true
        
        descriptionInput.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.07).isActive = true
        
        // Activity Time Input
        ActivityTimeInput.translatesAutoresizingMaskIntoConstraints = false
        ActivityTimeInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        ActivityTimeInput.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        ActivityTimeInput.topAnchor.constraint(equalTo:descriptionInput.bottomAnchor).isActive=true
        
        ActivityTimeInput.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.07).isActive = true
        
        // Activity Date Input
        ActivityDateInput.translatesAutoresizingMaskIntoConstraints = false
        ActivityDateInput.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        ActivityDateInput.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        ActivityDateInput.topAnchor.constraint(equalTo:ActivityTimeInput.bottomAnchor).isActive=true
        
        ActivityDateInput.heightAnchor.constraint(equalTo: popupView.heightAnchor, multiplier: 0.07).isActive = true
        
        // activity image
        activityImage.translatesAutoresizingMaskIntoConstraints = false
        activityImage.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive=true
        activityImage.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive=true
        activityImage.topAnchor.constraint(equalTo:ActivityDateInput.bottomAnchor).isActive=true
        
        activityImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25).isActive = true
        
        
        //post image
        
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        postImage.topAnchor.constraint(equalTo:activityImage.bottomAnchor).isActive=true
        
        postImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive=true
        postImage.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive=true
        
        cancel.translatesAutoresizingMaskIntoConstraints = false
        cancel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cancel.topAnchor.constraint(equalTo:activityImage.bottomAnchor).isActive=true
        
        cancel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive=true
        cancel.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive=true
        
        
        
        
        
        
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
    
    
    @objc func handlePost() {
        if ( GIDSignIn.sharedInstance()?.currentUser != nil)
        {
            updateFirebase(userid: (GIDSignIn.sharedInstance()?.currentUser.userID)!)
        }
        else if( AccessToken.current?.userID != nil)
        {
            updateFirebase(userid: AccessToken.current!.userID)
        }
        else if (Auth.auth().currentUser?.uid != nil)
        {
            updateFirebase(userid: Auth.auth().currentUser!.uid)
        }
        
        
        
    }
    private func updateFirebase(userid:String)
    {
        
        
        guard let postTitle = titleLabel.text, let address = addressInput.text,let description=descriptionInput.text,  let activityTime = ActivityTimeInput.text,let activityDate = ActivityDateInput.text else
        {
            print ("Form is not valid")
            return
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_image").child("\(imageName).jpg")
        if let uploadData = self.activityImage.image!.jpegData(compressionQuality: 0.06){
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
                        let values=["postTitle":postTitle,"address":address,"description":description,"activityTime":activityTime,"activityDate":activityDate,"postDate":result,"ActicityURL":downloadURL.absoluteString,"posterId":userid]
                        let postID = NSUUID().uuidString
                        let ref = Database.database().reference().child("post").child(postID)
                        
                        // let values=["name":username,"email":email,"profileImageURL":metadata.downloadUrl()]
                        ref.updateChildValues(values, withCompletionBlock: {(err,ref)
                            in
                            if err != nil
                            {
                                print(err as Any)
                                return
                            }
                            else{
                                print("update user successfully")
                                self.performSegue(withIdentifier: "toMain", sender: self)
                                
                            }
                            
                        })
                        
                    }
                    else {
                        print(error as Any)
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                }})}
        
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
