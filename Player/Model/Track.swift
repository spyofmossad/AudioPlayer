//
//  Track.swift
//  Player
//
//  Created by Dzmitry Navitski on 22.07.2021.
//

import Foundation

class Track {
    let name: String
    let url: URL
    var localUrl: URL?
    var metadata: Metadata?
    
    init(track: String, url: URL) {
        self.name = track
        self.url = url
        self.metadata = Metadata()
    }
}

struct Metadata {
    var artist: String?
    var album: String?
    var song: String?
    var genre: String?
    var year: String?
}

extension Track {
    public static var tracksList: [Track] {
        return [
            Track(track: "BMTH - Can you feel my heart",
                  url: URL(string: "https://www.dropbox.com/s/hx2ugkgk6gfu9qy/tagmp3_throne.mp3?dl=1")!),
            Track(track: "BMTH - Sleepwalking",
                  url: URL(string: "https://www.dropbox.com/s/n72ptdsgvbbgmut/tagmp3_Bring-Me-The-Horizon---Sleepwalking.mp3?dl=1")!),
            Track(track: "Korn - Word Up!",
                  url: URL(string: "https://www.dropbox.com/s/9xbiwux1e3375wk/tagmp3_korn_-_word-up.mp3?dl=1")!),
            Track(track: "Korn - Twisted Transistor",
                  url: URL(string: "https://www.dropbox.com/s/qfhrabduueoyyq4/tagmp3_korn_twisted-transistor_.mp3?dl=1")!)
        ]
    }
}
