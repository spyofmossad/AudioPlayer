//
//  NetworkManager.swift
//  Player
//
//  Created by Dzmitry Navitski on 22.07.2021.
//

import Foundation

class NetworkManager: NSObject {
    
    var downloadProgress: ((Float) -> ())?
    var downloadFinished: ((URL) -> ())?
    
    private var downloadTask: URLSessionDownloadTask?
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: .current)
    }()
    
    func resumeDownload(_ track: Track) {
        if let downloadTask = downloadTask {
            downloadTask.resume()
            return
        } else {
            downloadTask = urlSession.downloadTask(with: track.url)
            downloadTask?.resume()
        }
    }
    
    func pauseDownload() {
        self.downloadTask?.suspend()
    }
    
    func cancelDownload() {
        self.downloadTask?.cancel()
    }
}

extension NetworkManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download error: " + error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if downloadTask.error == nil {
            downloadFinished?(location)
            self.downloadTask = nil
        }
    }
}

extension NetworkManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.downloadProgress?(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
        }
    }
}
