//
//  PlayerView.swift
//  Player
//
//  Created by Dzmitry Navitski on 24.07.2021.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
        
    private lazy var trackName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var playPauseTrack: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playOnTap), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private lazy var trackDuration: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        return label
    }()
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    private var isPlaying = false {
        didSet {
            if isPlaying {
                playPauseTrack.setImage(UIImage(systemName: "pause"), for: .normal)
            } else {
                playPauseTrack.setImage(UIImage(systemName: "play"), for: .normal)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(playPauseTrack)
        self.addSubview(trackName)
        self.addSubview(progressBar)
        self.addSubview(trackDuration)
        
        NSLayoutConstraint.activate([
            playPauseTrack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playPauseTrack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            
            trackName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            trackName.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            
            progressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: trackName.bottomAnchor, constant: 10),
            progressBar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 80),
            progressBar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80),
            
            trackDuration.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            trackDuration.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -65)
        ]);
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func playOnTap() {
        isPlaying ? player?.pause() : player?.play()
        isPlaying = !isPlaying
    }
    var otherplayer: AVAudioPlayer?
    func play(_ track: Track) {
        if ((player?.currentItem?.asset) as? AVURLAsset)?.url == track.localUrl {
            playOnTap()
            return
        }
        
        player = AVPlayer(url: track.localUrl!)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { [unowned self] time in
            let duration = CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!), time = CMTimeGetSeconds(time)
            let progress = (time/duration)
            progressBar.progress = Float(progress)

            let minutes = Int(duration - time) / 60
            let seconds = Int(duration - time) - (minutes * 60)
            trackDuration.text = String(format: "%02i:%02i", minutes, seconds)
        })

        playPauseTrack.isEnabled = true
        trackName.text = track.name
        isPlaying = true
        player?.play()
    }
    
    func reset() {
        isPlaying = false
        player?.removeTimeObserver(self.timeObserver!)
        player = nil
        playPauseTrack.isEnabled = false
        trackDuration.text = "00:00"
        trackName.text = nil
        progressBar.progress = 0
    }
}

