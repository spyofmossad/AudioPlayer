//
//  SceneDelegate.swift
//  Player
//
//  Created by Dzmitry Navitski on 22.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let tracksViewController = TracksViewController(tracks: Track.tracksList)
        window.rootViewController = tracksViewController
       
        window.makeKeyAndVisible()
    }

}

