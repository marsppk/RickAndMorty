//
//  CharactersDetailsViewController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 04.12.2023.
//

import UIKit

class CharactersDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var character: Character? = nil
    private var location: Location?
    private var origin: Location?
    private var apiManager = APIManager()
    private enum Sections: Int, CaseIterable {
        case episodes
    }
    
    // MARK: - Subviews
    
    private let separator = Separator()
    private let separator1 = Separator()
    private let separator2 = Separator()
    private let separator3 = Separator()
    private let separator4 = Separator()
    private let separator5 = Separator()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = character?.image
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Name: " + (character?.name ?? "Unknown")
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = UIColor(named: "labels")
        return nameLabel
    }()
    
    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.text = "Status: " + (character?.status.rawValue ?? "-")
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        statusLabel.numberOfLines = 0
        statusLabel.textColor = UIColor(named: "labels")
        return statusLabel
    }()
    
    private lazy var speciesLabel: UILabel = {
        let speciesLabel = UILabel()
        speciesLabel.text = "Species: " + (character?.species ?? "-")
        speciesLabel.textAlignment = .center
        speciesLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        speciesLabel.numberOfLines = 0
        speciesLabel.textColor = UIColor(named: "labels")
        return speciesLabel
    }()
    
    private lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        let type = (character?.type ?? "Unknown")
        typeLabel.text = "Type: " + (type.isEmpty ? "-" : type)
        typeLabel.textAlignment = .center
        typeLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        typeLabel.numberOfLines = 0
        typeLabel.textColor = UIColor(named: "labels")
        return typeLabel
    }()
    
    private lazy var genderLabel: UILabel = {
        let genderLabel = UILabel()
        genderLabel.text = "Gender: " + (character?.gender.rawValue ?? "-")
        genderLabel.textAlignment = .center
        genderLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        genderLabel.numberOfLines = 0
        genderLabel.textColor = UIColor(named: "labels")
        return genderLabel
    }()
    
    private lazy var episodesLabel: UILabel = {
        let episodesLabel = UILabel()
        episodesLabel.text = "Episodes:"
        episodesLabel.textAlignment = .center
        episodesLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        episodesLabel.numberOfLines = 0
        episodesLabel.textColor = UIColor(named: "labels")
        return episodesLabel
    }()
    
    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.numberOfLines = 0
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        locationLabel.numberOfLines = 0
        locationLabel.textColor = UIColor(named: "labels")
        return locationLabel
    }()
    
    private lazy var originLabel: UILabel = {
        let originLabel = UILabel()
        originLabel.numberOfLines = 0
        originLabel.textAlignment = .center
        originLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        originLabel.numberOfLines = 0
        originLabel.textColor = UIColor(named: "labels")
        return originLabel
    }()
    
    private lazy var originHeaderLabel: UILabel = {
        let originHeaderLabel = UILabel()
        originHeaderLabel.text = "Location:"
        originHeaderLabel.textAlignment = .center
        originHeaderLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        originHeaderLabel.numberOfLines = 0
        originHeaderLabel.textColor = UIColor(named: "labels")
        return originHeaderLabel
    }()
    
    private lazy var locationHeaderLabel: UILabel = {
        let locationHeaderLabel = UILabel()
        locationHeaderLabel.text = "Origin:"
        locationHeaderLabel.textAlignment = .center
        locationHeaderLabel.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        locationHeaderLabel.numberOfLines = 0
        locationHeaderLabel.textColor = UIColor(named: "labels")
        return locationHeaderLabel
    }()
    
    private lazy var locationView: UIView = {
        let locationView = UIView()
        locationView.backgroundColor = UIColor(named: "labelBG")
        locationView.layer.cornerRadius = 12
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openLocation))
        locationView.addGestureRecognizer(tapGestureRecognizer)
        return locationView
    }()
    
    private lazy var originView: UIView = {
        let originView = UIView()
        originView.backgroundColor = UIColor(named: "labelBG")
        originView.layer.cornerRadius = 12
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openOrigin))
        originView.addGestureRecognizer(tapGestureRecognizer)
        return originView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EpisodeCell.self, forCellWithReuseIdentifier: EpisodeCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let generalStack: UIStackView = {
        let generalStack = UIStackView()
        generalStack.axis = .vertical
        generalStack.spacing = 10
        return generalStack
    }()
    
    private lazy var stackWithLocations: UIStackView = {
        let stackWithLocations = UIStackView()
        stackWithLocations.axis = .horizontal
        stackWithLocations.distribution = .fillEqually
        stackWithLocations.spacing = 10
        return stackWithLocations
    }()
    
    private lazy var stackWithHeaders: UIStackView = {
        let stackWithLocations = UIStackView()
        stackWithLocations.axis = .horizontal
        stackWithLocations.distribution = .fillEqually
        stackWithLocations.spacing = 10
        return stackWithLocations
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        configurateUI()
    }
    
    func setCharacter(data: Character) {
        character = data
    }
    
    private func getData() {
        if let character {
            if character.location.url == "" {
                locationLabel.text = "Unknown"
            }
            else {
                self.apiManager.getLocation(url: character.location.url) { location in
                    let newLocation = Location(
                        id: location.id,
                        name: location.name,
                        type: location.type,
                        dimension: location.dimension,
                        residents: location.residents,
                        url: location.url,
                        created: location.created
                    )
                    DispatchQueue.main.async {
                        self.location = newLocation
                        self.locationLabel.text = newLocation.name
                    }
                }
            }
            if character.origin.url == "" {
                originLabel.text = "Unknown"
            }
            else {
                self.apiManager.getLocation(url: character.origin.url) { origin in
                    let newLocation = Location(
                        id: origin.id,
                        name: origin.name,
                        type: origin.type,
                        dimension: origin.dimension,
                        residents: origin.residents,
                        url: origin.url,
                        created: origin.created
                    )
                    DispatchQueue.main.async {
                        self.origin = newLocation
                        self.originLabel.text = newLocation.name
                    }
                }
            }
        }
    }
    
    @objc private func openLocation() {
        if let location = location {
            let detailViewController = LocationsDetailsViewController()
            detailViewController.setLocation(data: location)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    @objc private func openOrigin() {
        if let origin = origin {
            let detailViewController = LocationsDetailsViewController()
            detailViewController.setLocation(data: origin)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    private func configurateUI() {
        view.backgroundColor = Appearance.bgImage
        
        view.addSubview(scrollView)
        scrollView.addSubview(generalStack)
        locationView.addSubview(locationLabel)
        originView.addSubview(originLabel)
        
        [locationHeaderLabel, originHeaderLabel].forEach {
            stackWithHeaders.addArrangedSubview($0)
        }
        
        [locationView, originView].forEach {
            stackWithLocations.addArrangedSubview($0)
        }
        
        [imageView, nameLabel, separator, statusLabel, separator1, speciesLabel, separator2, typeLabel, separator3, genderLabel, separator4, stackWithHeaders, stackWithLocations, separator5, episodesLabel, collectionView].forEach {
            generalStack.addArrangedSubview($0)
        }
        
        [scrollView, generalStack, imageView, collectionView, stackWithLocations, locationLabel, originLabel, stackWithHeaders].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            generalStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            generalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            generalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            generalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            generalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.widthAnchor.constraint(equalTo: generalStack.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            stackWithLocations.heightAnchor.constraint(equalToConstant: 120),
            stackWithHeaders.heightAnchor.constraint(equalToConstant: 20),
            locationLabel.centerXAnchor.constraint(equalTo: locationView.centerXAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: locationView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationView.leadingAnchor, constant: 2),
            locationLabel.trailingAnchor.constraint(equalTo: locationView.trailingAnchor, constant: -2),
            originLabel.centerXAnchor.constraint(equalTo: originView.centerXAnchor),
            originLabel.centerYAnchor.constraint(equalTo: originView.centerYAnchor),
            originLabel.leadingAnchor.constraint(equalTo: originView.leadingAnchor, constant: 2),
            originLabel.trailingAnchor.constraint(equalTo: originView.trailingAnchor, constant: -2),
        ])
    }
}

extension CharactersDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = Sections.allCases[section]
        
        switch sectionType {
        case .episodes:
            return character?.episode.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = Sections.allCases[indexPath.section]
        
        switch sectionType {
        case .episodes:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.identifier, for: indexPath) as? EpisodeCell else { return UICollectionViewCell() }
            cell.configure(name: character?.episode[indexPath.row].name ?? "")
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CharactersDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = EpisodesDetailsViewController()
        detailViewController.setEpisode(data: character?.episode[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

