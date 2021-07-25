//
//  TrackViewCell.swift
//  Player
//
//  Created by Dzmitry Navitski on 22.07.2021.
//

import UIKit

class TrackViewCell: UITableViewCell {
    
    var playTrackCallback: ((Track?) -> ())?
    
    private lazy var trackName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var downloadStartPause: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(downloadOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var playPauseTrack: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "playpause"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playPauseOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var progress: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private var tracksManager: TracksManager!
    private var isDownloading = false {
        didSet {
            if isDownloading {
                downloadStartPause.setImage(UIImage(systemName: "icloud.slash"), for: .normal)
            } else {
                downloadStartPause.setImage(UIImage(systemName: "icloud.and.arrow.down"), for: .normal)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(trackName)
        contentView.addSubview(downloadStartPause)
        contentView.addSubview(progress)
        contentView.addSubview(playPauseTrack)
        NSLayoutConstraint.activate([
            trackName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            trackName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            
            progress.leftAnchor.constraint(equalTo: trackName.rightAnchor, constant: 16),
            progress.rightAnchor.constraint(equalTo: downloadStartPause.leftAnchor, constant: -16),
            progress.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            
            downloadStartPause.heightAnchor.constraint(equalToConstant: 25),
            downloadStartPause.widthAnchor.constraint(equalToConstant: 30),
            downloadStartPause.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            downloadStartPause.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            
            playPauseTrack.heightAnchor.constraint(equalToConstant: 25),
            playPauseTrack.widthAnchor.constraint(equalToConstant: 25),
            playPauseTrack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            playPauseTrack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0)
        ]);
        
        playPauseTrack.isHidden = true;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(tracksManager: TracksManager) {
        self.tracksManager = tracksManager
        trackName.text = tracksManager.track.name
        
        if tracksManager.isTrackDownloaded {
            downloadStartPause.isHidden = true
            progress.isHidden = true
            playPauseTrack.isHidden = false
        } else {
            downloadStartPause.isHidden = false
            progress.isHidden = false
            progress.progress = 0
            playPauseTrack.isHidden = true
        }
        
        tracksManager.downloadProgress = { [unowned self] (progressUpd) in
            self.progress.progress = progressUpd
        }
        tracksManager.downloadFinished = { [unowned self] in
            isDownloading = !isDownloading
            self.downloadStartPause.isHidden = true
            self.progress.isHidden = true
            self.playPauseTrack.isHidden = false
        }
    }
    
    @objc private func downloadOnTap(_ sender: UIButton) {
        isDownloading ? tracksManager.downloadPause() : tracksManager.downloadResume()
        isDownloading = !isDownloading
    }

    @objc private func playPauseOnTap(_ sender: UIButton) {
        playTrackCallback?(tracksManager.track)
    }
}
