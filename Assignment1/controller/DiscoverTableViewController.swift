//
//  DiscoverViewController.swift
//  Assignment1
//
//  Created by linshun on 2/1/20.
//  Copyright © 2020 Shunyang Dong. All rights reserved.
//

import UIKit
import Firebase

class DiscoverTableViewController: UITableViewController {
    let cellId = "cellId"
    
    @IBAction func popup(_ sender: Any) {
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpScreen") as!PopUpViewController
        self.addChild(popupVC)
        self.view.addSubview(popupVC.view)
        popupVC.didMove(toParent: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.showNavigationBar()
        self.observePosts()
        handleNavigation()
        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)
        
        
    }
    private func handleNavigation()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        
    }
    @objc private func handleBack()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
        let navigationControlr = UINavigationController(rootViewController: vc)
        // vc.modalPresentationStyle = .fullScreen
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
        
    }
    
    
    private func showDetailsController(_ post: Post) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! PostDetailsViewController
        detailController.post =  post
        let navigationControlr = UINavigationController(rootViewController: detailController)
        navigationControlr.modalPresentationStyle = .fullScreen
        self.present(navigationControlr, animated: true, completion: nil)
    }
    
    
    var posts = [Post]()
    
    private func  observePosts()
    {
        
        
        let PostMessagesRef = Database.database().reference().child("post")
        
        PostMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let postid = snapshot.key
            let messagesRef = Database.database().reference().child("post").child(postid)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let post = Post(dictionary: dictionary)
                
                
                self.posts.append(post)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        
        cell.post = post
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.3
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        showDetailsController(post)
        
    }
    
}
