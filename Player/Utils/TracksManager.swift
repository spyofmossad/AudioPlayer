//
//  TracksRepository.swift
//  Player
//
//  Created by Dzmitry Navitski on 24.07.2021.
//

import Foundation

class TracksManager {
    
    public var downloadProgress: ((Float) -> ())?
    public var downloadFinished: (() -> ())?
    
    public var isTrackDownloaded: Bool {
        return track.localUrl != nil
    }
    
    var track: Track
    private var networkManager: NetworkManager
    private var fileManager: FileManager
    private var defaultDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private var localUrl: URL {
        return defaultDirectory.appendingPathComponent(track.url.lastPathComponent)
    }
    
    init(track: Track, networkManager: NetworkManager, fileManager: FileManager) {
        self.track = track
        self.networkManager = networkManager
        self.fileManager = fileManager
        
        networkManager.downloadFinished = { [unowned self] (location) in
            try? FileManager.default.copyItem(at: location, to: localUrl)
            self.track.localUrl = localUrl
            downloadFinished?()
        }
        networkManager.downloadProgress = { [unowned self] (progress) in
            self.downloadProgress?(progress)
        }
        
        if fileManager.fileExists(atPath: localUrl.path) {
            track.localUrl = localUrl
        }
    }
    
    func getFile() {
        if isTrackDownloaded {
            track.localUrl = defaultDirectory.appendingPathComponent(track.name)
        } else {
            networkManager.resumeDownload(track)
        }
    }
    
    func deleteFile() {
        if isTrackDownloaded {
            try? fileManager.removeItem(at: localUrl)
            track.localUrl = nil
        } else {
            networkManager.cancelDownload()
        }
    }
    
    func downloadPause() {
        networkManager.pauseDownload()
    }
    
    func downloadResume() {
        networkManager.resumeDownload(track)
    }
}
