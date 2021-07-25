//
//  TrackDetailsViewController.swift
//  Player
//
//  Created by Dzmitry Navitski on 22.07.2021.
//

import UIKit
import AVFoundation

class TrackDetailsViewController: UIViewController {
    
    public var dismissCallback: (() -> ())?
    
    private lazy var author: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var trackName: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var album: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var year: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var genre: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var delete: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelsStack: UIStackView = {
        let labelsStack = UIStackView(arrangedSubviews: [author, trackName, album, year, genre])
        labelsStack.axis = .vertical
        labelsStack.distribution = .fillEqually
        labelsStack.spacing = 15
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        return labelsStack
    }()
    
    private var track: Track
    
    init(track: Track) {
        self.track = track
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        self.view.addSubview(labelsStack)
        self.view.addSubview(delete)
        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            labelsStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 40),
            labelsStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40),
            
            delete.topAnchor.constraint(equalTo: labelsStack.bottomAnchor, constant: 30),
            delete.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            delete.widthAnchor.constraint(equalToConstant: 136),
            delete.heightAnchor.constraint(equalToConstant: 41)
        ]);
        
        parseMetadata(track)
    }
    
    @objc private func deleteOnTap() {
        self.dismiss(animated: true, completion: dismissCallback)
    }
    
    private func parseMetadata(_ track: Track) {
        guard let localUrl = track.localUrl else {
            author.text = "Track metadata is unavaliable. You need to download file first."
            return
        }
        let asset = AVAsset(url: localUrl)
        let meta = asset.metadata(forFormat: .id3Metadata)
        for id3Metadata in meta {
            let metadataIdentifier = id3Metadata.identifier ?? AVMetadataIdentifier(rawValue: "")
            switch metadataIdentifier {
            case .id3MetadataTitleDescription:
                trackName.text = "Track: " + (id3Metadata.value?.description ?? "n/a")
            case .id3MetadataAlbumTitle:
                album.text = "Album: " + (id3Metadata.value?.description ?? "n/a")
            case .id3MetadataYear:
                year.text = "Year: " + (id3Metadata.value?.description ?? "n/a")
            case .id3MetadataLeadPerformer:
                author.text = "Album: " + (id3Metadata.value?.description ?? "n/a")
            case .id3MetadataContentType:
                genre.text = "Genre: " + (id3Metadata.value?.description ?? "n/a")
            default:
                print("Unexpected value")
            }
        }
    }
}
