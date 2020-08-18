//
//  chatlogController.swift
//  Assignment1
//
//  Created by linshun on 20/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit
import MobileCoreServices
import AVFoundation


class chatlogController : UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate
    
    
{
    let cellId = "cellId"
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    var messages = [Message]()
    let activityIndicatorView: UIActivityIndicatorView = {
          let aiv = UIActivityIndicatorView(style: .large)
          
          aiv.translatesAutoresizingMaskIntoConstraints = false
          aiv.hidesWhenStopped = true
          return aiv
      }()
    func observeMessages() {
        
        
        
        guard let toId = user?.id else {
            return
        }
        guard let uid = getFromID() else {
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                
                
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    // scroll to  the last index
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
        
        
    }
    
  /*  lazy var inputTextField : UITextField =
        {
            let textField = UITextField()
            textField.placeholder = "Enter message ..."
            textField.translatesAutoresizingMaskIntoConstraints =  false
            textField.delegate = self
            return textField
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive
        
        
        
        setupKeyboardObservers()
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
    }
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    lazy var inputContainerView: ChatInputContainerView = {
        
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        chatInputContainerView.chatLogController = self
        return chatInputContainerView   
       
    }()
    
    @objc func handleUploadTap()
    {
        let imagePickerController =  UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
           
            handleVideoSelectedForUrl( videoUrl.absoluteURL)
        } else {
            handleImageSelectedForInfo(info)
        }
        

        
    
      
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
        let filename = UUID().uuidString + ".mov"
       
        let ref = Storage.storage().reference().child("message_movies").child(filename)
      //guard let uploadUrl = URL(string:url)else { return  }
        
        let uploadTask = ref.putFile(from: url, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload movie:", err)
                return
            }
            
            ref.downloadURL(completion: { (downloadUrl, err) in
                if let err = err {
                    print("Failed to get download url:", err)
                    return
                }
                
                guard let downloadUrl = downloadUrl else { return }
                
                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
                    
                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: { (imageUrl) in
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": downloadUrl.absoluteString as AnyObject]
                        self.sendMessageWithProperties(properties)
                       // print(imageUrl)
                        
                    })
                }

            })
        })

        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }

        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.name
        }
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
          let asset = AVAsset(url: fileUrl)
          let imageGenerator = AVAssetImageGenerator(asset: asset)
          
          do {
          
              let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
              return UIImage(cgImage: thumbnailCGImage)
              
          } catch let err {
              print(err)
          }
          
          return nil
      }
      
    
       fileprivate func handleImageSelectedForInfo(_ info: [UIImagePickerController.InfoKey : Any]) {
         var selectedImageFromPicker: UIImage?
         
         if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
             selectedImageFromPicker = editedImage
         } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             
             selectedImageFromPicker = originalImage
         }
         
         if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage, completion: { (imageUrl) in
                 self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
             })
         }
     }
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
           let imageName = UUID().uuidString
           let ref = Storage.storage().reference().child("message_images").child(imageName)
           
           if let uploadData = image.jpegData(compressionQuality: 0.2) {
               ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                   
                   if error != nil {
                       print("Failed to upload image:", error!)
                       return
                   }
                   
                   ref.downloadURL(completion: { (url, err) in
                       if let err = err {
                           print(err)
                           return
                       }
                       completion(url?.absoluteString ?? "")
                   })
                   
               })
           }
       }
    @objc func handleSend()
    {
        
        let properties = ["text": inputContainerView.inputTextField.text!]
        sendMessageWithProperties(properties as [String : AnyObject])
        
        
    }
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String,image:UIImage)
    {
        
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
        
    }
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        let ref = Database.database().reference().child("messages")
        let childRef  = ref.childByAutoId()
        let toId = user!.id!
        let timestamp = Int(Date().timeIntervalSince1970)
        if let fromId = getFromID()
        {
            
            var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
            //key $0, value $1
            
            properties.forEach({values[$0] = $1})
            
            childRef.updateChildValues(values,withCompletionBlock: {(error,ref)
                in
                if error != nil
                {
                    print(error as Any)
                    return
                }
                self.inputContainerView.inputTextField.text = nil
                guard let messageId = childRef.key else { return }
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId).child(messageId)
                userMessagesRef.setValue(1)
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId).child(messageId)
                recipientUserMessagesRef.setValue(1)
            })
            
        }
       
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    
    
    
    
    @objc func handleMap()
    {
        let MaplogController =  MapViewController(nibName: nil, bundle: nil )
        
        MaplogController.user = user
        
        
        navigationController?.pushViewController(MaplogController, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController  = self
        let message = messages[indexPath.item]
        
        cell.message = message
        
        cell.textView.text = message.text
        
      
        setupCell(cell, message: message)
        
        
        
        if let text = message.text
        {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
            cell.textView.isHidden = false
        }else if message.imageUrl != nil
        {
            // an image message
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden  = true
        }
      // if video url = nil then hidden , else then show
        cell.playButton.isHidden = message.videoUrl == nil
        
        
        return cell
    }
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageURL {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        if (message.fromId == getFromID())
        {
            
            cell.bubbleView.backgroundColor =  ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }
        else
        {
            cell.bubbleView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
        
        
        
        
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80;
        let message = messages[indexPath.item]
        // check the type of message and apply the bubble size
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        }else if let imageWidth  = message.imageWidth?.floatValue,let imageHeight = message.imageHeight?.floatValue
        {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    var startingFrame:CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    func performZoomInForStartingImageView(startingImageView:UIImageView)
    {
        self.startingImageView = startingImageView
        // the location and the size of the image
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        self.startingImageView?.isHidden = true
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor =  .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow
        {
            let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
            blackBackgroundView =  UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            })
        }
        
    }
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer)
    {
        
        if let zoomOutImageView = tapGesture.view
        {
            
            
            // animate back to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            })
        }
        
    }
    
    var playerLayer: AVPlayerLayer?
       var player: AVPlayer?
    func performVideo(_ url:URL)
    {
        if let keyWindow = UIApplication.shared.keyWindow
               {
                  
                   blackBackgroundView =  UIView(frame: keyWindow.frame)
                   blackBackgroundView?.backgroundColor = .black
                   blackBackgroundView?.alpha = 0
                   keyWindow.addSubview(blackBackgroundView!)
                blackBackgroundView?.addSubview(activityIndicatorView)
                activityIndicatorView.centerXAnchor.constraint(equalTo: blackBackgroundView!.centerXAnchor).isActive = true
                activityIndicatorView.centerYAnchor.constraint(equalTo: blackBackgroundView!.centerYAnchor).isActive = true
                       activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
                       activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                blackBackgroundView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleVideoZoomOut)))
                  
                   UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                       self.blackBackgroundView?.alpha = 1
                       self.inputContainerView.alpha = 0
                    self.player = AVPlayer(url: url)
                                         
                    self.playerLayer = AVPlayerLayer(player: self.player)
                    self.blackBackgroundView!.layer.addSublayer(self.playerLayer!)
                    self.playerLayer!.frame = self.blackBackgroundView!.frame
                                         
                    self.player!.play()
                    self.activityIndicatorView.startAnimating()
                    
                                  
                   })
               }
        
    }
    
    @objc func handleVideoZoomOut(_ tapGesture: UITapGestureRecognizer)
       {
           
           if let zoomOutImageView = tapGesture.view
           {
               
               
               // animate back to controller
               zoomOutImageView.layer.cornerRadius = 16
               zoomOutImageView.clipsToBounds = true
               UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                   
                zoomOutImageView.frame = UIApplication.shared.keyWindow?.frame as! CGRect
                   self.blackBackgroundView?.alpha = 0
                   self.inputContainerView.alpha = 1
                   
               }, completion: { (completed) in
                   zoomOutImageView.removeFromSuperview()
                   self.startingImageView?.isHidden = false
                self.playerLayer?.removeFromSuperlayer()
                self.player?.pause()
                self.activityIndicatorView.stopAnimating()
               })
           }
           
       }
    
    
    
}

fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
func getFromID() -> String? {
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

