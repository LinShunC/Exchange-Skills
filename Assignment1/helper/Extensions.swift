//
//  Extensions.swift
//  gameofchats
//
//  Created by Brian Voong on 7/5/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()
extension UIViewController
{
    func HideKeyBoard()  {
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(Tap)
    }
    @objc func DismissKeyboard(){
        self.view.endEditing(true)
        //UIApplication.shared.sendAction("resignFirstResponder", to:nil, from:nil, for:nil)
    
        
    }
}
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        if let cachedImage = imageCache.object (forKey: urlString as NSString) as? UIImage
        {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                //   cell.imageView?.image = UIImage(data: data!)
                if let downloadImage = UIImage(data: data!)
                {
                    imageCache.setObject(downloadImage, forKey: urlString as NSString)
                    self.image = downloadImage
                }
                
                
                
            }
            
            
        }).resume()
        /* self.image = nil
         
         //check cache for image first
         if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
         self.image = cachedImage
         return
         }
         
         //otherwise fire off a new download
         let url = URL(string: urlString)
         URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
         
         //download hit an error so lets return out
         if let error = error {
         print(error)
         return
         }
         
         DispatchQueue.main.async(execute: {
         
         if let downloadedImage = UIImage(data: data!) {
         imageCache.setObject(downloadedImage, forKey: urlString as NSString)
         
         self.image = downloadedImage
         }
         })
         
         }).resume()*/
    }
    
}


