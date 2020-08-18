//
//  VideoLauncher.swift
//  Youtube
//
//  Created by linshun on 2/8/20.
//  Copyright © 2020 lin shun. All rights reserved.
//

import UIKit
import AVFoundation


class VideoPlayerView: UIView {
     var videoUrl:URL?
   {
        didSet
        
        {}
    }
    let acticityIndicatorView :UIActivityIndicatorView =
    {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    let videoLengthLabel: UILabel =
    {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return  label
    }()
    let currentTimeLabel : UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return  label
    }()
    lazy var videoSlider: UISlider =
        {
            let slider = UISlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.minimumTrackTintColor = .red
            slider.maximumTrackTintColor = .white
            
            slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
            return slider
    }()
    var isPlaying = false
    @objc func handleSliderChange()
    {
        // move to the slider time
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            })
        }
    }
    @objc func handlePause (){
        
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
        
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupPlayerView()
        setupGradientLayer()
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(acticityIndicatorView)
        acticityIndicatorView.centerYAnchor.constraint(equalTo:controlsContainerView.centerYAnchor).isActive = true
        acticityIndicatorView.centerXAnchor.constraint(equalTo:controlsContainerView.centerXAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        
        pausePlayButton.centerYAnchor.constraint(equalTo:controlsContainerView.centerYAnchor).isActive = true
        pausePlayButton.centerXAnchor.constraint(equalTo:controlsContainerView.centerXAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor,constant: -4).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant:  -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        
        
        controlsContainerView.addSubview(currentTimeLabel)
        
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant:  -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor,constant: 8).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
        
        
        
    }
    var player : AVPlayer?
    private func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = URL(string: urlString)
        {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer (player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            // check if the video is play
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            // track player progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds) / 60)
                
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                // move the slider thumb
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self.videoSlider.value = Float(seconds / durationSeconds)
                    
                }
                
            })
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // if video is played , stop animating
        if keyPath == "currentItem.loadedTimeRanges"
        {
            acticityIndicatorView.stopAnimating()
            
            // make sure the indicator appear when the video start to play
            controlsContainerView.backgroundColor = .clear
            
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if  let duration  = player?.currentItem?.duration{
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    private func setupGradientLayer()
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor,UIColor.black.cgColor]
        controlsContainerView.layer.addSublayer(gradientLayer)
        gradientLayer.locations = [0.7 , 1.2]
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer()
    {
        if let keyWindow  = UIApplication.shared.keyWindow
        {
            let view = UIView(frame: keyWindow.frame)
            keyWindow.addSubview(view)
            view.backgroundColor = .white
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame =  CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }) { (_) in
                //UIApplication.shared.setStatusBarHidden(true, with: .fade)
                UIApplication.shared.isStatusBarHidden = true
            }
        }
    }
}

