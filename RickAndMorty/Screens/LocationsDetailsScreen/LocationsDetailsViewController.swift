//
//  LocationsDetailsViewController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 08.12.2023.
//

import UIKit

class LocationsDetailsViewController: UIViewController {
    
    private var location: Location?
    private var residents: [Character] = []
    private var apiManager = APIManager()
    
    private enum Sections: Int, CaseIterable {
        case residents
    }
    
    private let separator = Separator()
    private let separator1 = Separator()
    private let separator2 = Separator()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Name: " + (location?.name ?? "Unknown")
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = UIColor(named: "labels")
        return nameLabel
    }()
    
    private lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.text = "Type: " + (location?.type ?? "Unknown")
        typeLabel.textAlignment = .center
        typeLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        typeLabel.numberOfLines = 0
        typeLabel.textColor = UIColor(named: "labels")
        return typeLabel
    }()
    
    private lazy var dimensionLabel: UILabel = {
        let dimensionLabel = UILabel()
        let label = (location?.dimension ?? "Unknown")
        dimensionLabel.text = "Dimension: " + (label != "" ? label : "-")
        dimensionLabel.textAlignment = .center
        dimensionLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        dimensionLabel.numberOfLines = 0
        dimensionLabel.textColor = UIColor(named: "labels")
        return dimensionLabel
    }()
    
    private lazy var residentsLabel: UILabel = {
        let residentsLabel = UILabel()
        residentsLabel.text = "Residents:"
        residentsLabel.textAlignment = .center
        residentsLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        residentsLabel.numberOfLines = 0
        residentsLabel.textColor = UIColor(named: "labels")
        return residentsLabel
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.identifier)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getData()
    }
    
    func setupUI() {
        view.backgroundColor = Appearance.bgImage
        view.addSubview(scrollView)
        view.addSubview(activityIndicatorView)
        scrollView.addSubview(generalStack)
        
        [nameLabel, separator, typeLabel, separator1, dimensionLabel, separator2, residentsLabel, collectionView].forEach {
            generalStack.addArrangedSubview($0)
        }
        
        [scrollView, generalStack, collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            generalStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            generalStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            generalStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            generalStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            generalStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setLocation(data: Location) {
        self.location = data
    }
    
    private func getImages(character: NetworkingCharacter, completion: @escaping ((Character) -> Void)) {
        
        self.apiManager.getImage(characterImage: character.image) { [weak self] imageData in
            guard let self = self else { return }
            self.getEpisodesForCharacter(character: character) { episodes in
                let newCharacter = Character(
                    id: character.id,
                    name: character.name,
                    status: character.status,
                    species: character.species,
                    type: character.type,
                    gender: character.gender,
                    origin: character.origin,
                    location: character.location,
                    image: UIImage(data: imageData),
                    episode: episodes,
                    url: character.url,
                    created: character.created
                )
                completion(newCharacter)
            }
        }
    }

    private func getEpisodesForCharacter(character: NetworkingCharacter, completion: @escaping ([Episode]) -> Void) {
        var episodes: [Episode] = []
        
        for episodeURL in character.episode {
            self.apiManager.getEpisode(url: episodeURL) { episode in
                let newEpisode = Episode(
                    id: episode.id,
                    name: episode.name,
                    airDate: episode.airDate,
                    episode: episode.episode,
                    characters: episode.characters,
                    url: episode.url,
                    created: episode.created
                )
                episodes.append(newEpisode)
                if episodes.count == character.episode.count {
                    completion(episodes)
                }
            }
        }
    }
    
    private func getCharactersForLocation(location: Location, completion: @escaping ([Character]) -> Void) {
        var characters: [Character] = []
        var fetchedCharacters = 0
        for characterURL in location.residents {
            self.apiManager.getCharacter(url: characterURL) { character in
                self.getImages(character: character) { finalCharater in
                    fetchedCharacters += 1
                    characters.append(finalCharater)
                    if characters.count == location.residents.count {
                        completion(characters)
                    }
                }
            }
        }
    }
    
    func getData() {
        residents = []
        if let location {
            if location.residents.count == 0 {
                residentsLabel.text = "Residents: -"
            }
            else {
                self.activityIndicatorView.startAnimating()
                getCharactersForLocation(location: location) { residents in
                    self.residents = residents
                    self.residents = self.residents.sorted { $0.id < $1.id }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.activityIndicatorView.stopAnimating()
                    }
                }
            }
        }
    }
}


extension LocationsDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = Sections.allCases[section]
        
        switch sectionType {
        case .residents:
            return residents.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = Sections.allCases[indexPath.section]
        
        switch sectionType {
        case .residents:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else { return UICollectionViewCell() }
            cell.configure(image: residents[indexPath.row].image)
            return cell
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension LocationsDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
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
        let detailViewController = CharactersDetailsViewController()
        detailViewController.setCharacter(data: residents[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

