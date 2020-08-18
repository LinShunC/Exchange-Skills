//
//  ChatMessageCell.swift
//  gameofchats
//
//  Created by Brian Voong on 7/12/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController: chatlogController?
    var message: Message?
    
    /*let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()*/
    // should lazy var or the function doesnot work
    lazy var  playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("play video", for: .normal)
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    //var playerLayer: AVPlayerLayer?
    //var player: AVPlayer?
    
    @objc func handlePlay()
    {
 
      
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString)
        {
            //self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
            
            self.chatLogController?.performVideo(url)
            
           
          /*  player = AVPlayer(url: url)
            
            // To do .. using cache memory storage  to cache the video
            playerLayer = AVPlayerLayer(player: player)
            playerLayer!.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            //self.chatLogController?.performZoomInForStartingVideoView(player: AVPlayer)
            
            player!.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true*/
           
        }
        
    }
    //    @objc private func handleBack()
    //    {
    //          player?.pause()
    //        let vc = chatLogController?.storyboard?.instantiateViewController(withIdentifier: "MessageVC") as! MessageTableViewController
    //        let navigationControlr = UINavigationController(rootViewController: vc)
    //        // vc.modalPresentationStyle = .fullScreen
    //        navigationControlr.modalPresentationStyle = .fullScreen
    //        chatLogController?.present(navigationControlr, animated: true, completion: nil)
    //
    //    }
   /* override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }*/

    
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = .white
        tv.isEditable = false
        return tv
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.image = UIImage(named: "nedstark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var  messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true;
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    @objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        if let imageView = tapGesture.view as? UIImageView {
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
        }
    }
    static let blueColor = UIColor(red:0.00, green:0.54, blue:0.98, alpha:1.0)
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        bubbleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        //x,y,w,h
        
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        /*bubbleView.addSubview(activityIndicatorView)
        //x,y,w,h
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true*/
        //x,y,w,h
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        //x,y,w,h
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        //        bubbleViewLeftAnchor?.active = false
        
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //ios 9 constraints
        //x,y,w,h
        //        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        //        textView.widthAnchor.constraintEqualToConstant(200).active = true
        
        
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
