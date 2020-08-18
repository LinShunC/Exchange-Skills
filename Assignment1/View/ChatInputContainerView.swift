//
//  ChatInputContainerView.swift
//  Assignment1
//
//  Created by linshun on 14/5/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView ,UITextFieldDelegate{
    
    var chatLogController : chatlogController?
    {
        didSet
        {
            sendButton.addTarget(chatLogController, action: #selector(chatlogController.handleSend), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: chatLogController, action: #selector(chatlogController.handleUploadTap)))
            googleButton.addTarget(chatLogController, action: #selector(chatlogController.handleMap), for: .touchUpInside)
            
        }
    }
    lazy var inputTextField : UITextField =
        {
            let textField = UITextField()
            textField.placeholder = "Enter message ..."
            textField.translatesAutoresizingMaskIntoConstraints =  false
            textField.delegate = self
            return textField
    }()
    let sendButton : UIButton =
    {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        return sendButton
    }()
    
    let googleButton : UIButton =
    {
        let googleButton = UIButton(type: .system)
        let image = UIImage(named: "googleTest")
        googleButton.setBackgroundImage(image, for: .normal)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        return googleButton
    }()
    
    let uploadImageView:UIImageView =
    {
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled=true
        uploadImageView.image=UIImage(named: "uploadImage")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        return uploadImageView
        
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        backgroundColor = .white
        
        
        
        
        addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        addSubview(googleButton)
        
        googleButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        googleButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        googleButton.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.1).isActive = true
        googleButton.heightAnchor.constraint(equalTo:heightAnchor).isActive = true
        
        addSubview(sendButton)
        
        sendButton.trailingAnchor.constraint(equalTo: googleButton.leadingAnchor,constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: widthAnchor,multiplier: 0.1).isActive = true
        sendButton.heightAnchor.constraint(equalTo:heightAnchor).isActive = true
        
        
        
        addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo:
            uploadImageView.rightAnchor,constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1.00)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo:topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
           return true
       }
       
}
