//
//  ViewController.swift
//  MixologyMaster_IOS
//
//  Created by Inna Maximova on 2023-04-15.
//

import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    var player: AVPlayer?
    
    // viewDidLoad is called once the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Play video on view load.
        if let videoURL = Bundle.main.url(forResource: "myVideo", withExtension: "mov") {
            player = AVPlayer(url: videoURL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.view.bounds
            playerLayer.videoGravity = .resizeAspect
            self.view.layer.insertSublayer(playerLayer, at: 0)
            
            // Repeat the video when it finishes.
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
            }
            
            player?.play()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add observer to resume video when app returns to foreground.
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Remove observer when view disappears.
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // Function to resume video when app returns to foreground.
    @objc func applicationWillEnterForeground() {
        player?.play()
    }
    
}

