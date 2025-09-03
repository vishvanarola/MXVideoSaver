//
//  VideoPlayerView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerVC = AVPlayerViewController()
        playerVC.showsPlaybackControls = true
        let player = AVPlayer(url: videoURL)
        playerVC.player = player
        player.play()
        return playerVC
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
