//
//  ViewController.swift
//  Player
//
//  Created by Dzmitry Navitski on 22.07.2021.
//

import UIKit

class TracksViewController: UIViewController {
    
    private let cellId = "TrackCell"
    private let cellHeight: CGFloat = 60
    private var tracksList: [Track]
    
    lazy var safeArea: UILayoutGuide = {
        return view.layoutMarginsGuide
    }()
    
    lazy var tracksTable: UITableView = {
        let table = UITableView()
        table.register(TrackViewCell.self, forCellReuseIdentifier: cellId)
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView()
        return table
    }()
    
    lazy var tableHeaderPlayer: PlayerView = {
        PlayerView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: cellHeight))
    }()
    
    init(tracks: [Track]) {
        tracksList = tracks
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tracksTable)
        NSLayoutConstraint.activate([
            tracksTable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            tracksTable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            tracksTable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            tracksTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)
        ])
    }
}

extension TracksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackManager = TracksManager(track: tracksList[indexPath.row], networkManager: NetworkManager(), fileManager: FileManager.default)
        let detailsVC = TrackDetailsViewController(track: trackManager.track)
        
        detailsVC.dismissCallback = { [unowned self] in
            trackManager.deleteFile()
            self.tableHeaderPlayer.reset()
            self.tracksTable.reloadData()
        }
        
        self.present(detailsVC, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderPlayer
    }
}

extension TracksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TrackViewCell {
            let trackManager = TracksManager(track: tracksList[indexPath.row], networkManager: NetworkManager(), fileManager: FileManager.default)
            cell.setupWith(tracksManager: trackManager)
            cell.playTrackCallback = { [unowned self] (track) in
                if let track = track {
                    self.tableHeaderPlayer.play(track)
                    tableView.reloadData()
                }
            }
            return cell
        }
        return UITableViewCell()
    }
}
