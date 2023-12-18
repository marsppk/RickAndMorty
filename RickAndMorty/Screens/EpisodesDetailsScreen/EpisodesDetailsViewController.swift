//
//  EpisodesDetailsViewController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 07.12.2023.
//

import UIKit

class EpisodesDetailsViewController: UIViewController {
    
    private var episode: Episode?
    private var characters: [Character] = []
    private var apiManager = APIManager()
    
    private enum Sections: Int, CaseIterable {
        case characters
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
        nameLabel.text = "Name: " + (episode?.name ?? "Unknown")
        nameLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor(named: "labels")
        return nameLabel
    }()
    
    private lazy var airDateLabel: UILabel = {
        let airDateLabel = UILabel()
        airDateLabel.text = "Air date: " + (episode?.airDate ?? "Unknown")
        airDateLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        airDateLabel.textAlignment = .center
        airDateLabel.numberOfLines = 0
        airDateLabel.textColor = UIColor(named: "labels")
        return airDateLabel
    }()
    
    private lazy var episodeLabel: UILabel = {
        let episodeLabel = UILabel()
        if let episode = episode?.episode {
            let indexWithS = String(episode.prefix(3))
            let indexWithoutS = String(Int(indexWithS.suffix(2)) ?? 0)
            let episodeIndex = String(Int(episode.suffix(2)) ?? 0)
            episodeLabel.text = "Episode: Season " + indexWithoutS + ", Episode " + episodeIndex
        }
        episodeLabel.textAlignment = .center
        episodeLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        episodeLabel.numberOfLines = 0
        episodeLabel.textColor = UIColor(named: "labels")
        return episodeLabel
    }()
    
    private lazy var charactersLabel: UILabel = {
        let charactersLabel = UILabel()
        charactersLabel.text = "Characters:"
        charactersLabel.font = UIFont(name: "GetSchwifty-Regular", size: 30)
        charactersLabel.textAlignment = .center
        charactersLabel.numberOfLines = 0
        charactersLabel.textColor = UIColor(named: "labels")
        return charactersLabel
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
        getData()
        setupUI()
    }
    
    func setEpisode(data: Episode?) {
        self.episode = data
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
    
    private func getCharactersForEpisode(episode: Episode, completion: @escaping ([Character]) -> Void) {
        var characters: [Character] = []
        var fetchedCharacters = 0
        for characterURL in episode.characters {
            self.apiManager.getCharacter(url: characterURL) { character in
                self.getImages(character: character) { finalCharater in
                    fetchedCharacters += 1
                    characters.append(finalCharater)
                    if characters.count == episode.characters.count {
                        completion(characters)
                    }
                }
            }
        }
    }
    
    func getData() {
        characters = []
        if let episode {
            self.activityIndicatorView.startAnimating()
            getCharactersForEpisode(episode: episode) { characters in
                self.characters = characters
                self.characters = self.characters.sorted { $0.id < $1.id }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = Appearance.bgImage
        view.addSubview(scrollView)
        view.addSubview(activityIndicatorView)
        scrollView.addSubview(generalStack)
        
        [nameLabel, separator, airDateLabel, separator1, episodeLabel, separator2, charactersLabel, collectionView].forEach {
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
}

extension EpisodesDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = Sections.allCases[section]
        
        switch sectionType {
        case .characters:
            return characters.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = Sections.allCases[indexPath.section]
        
        switch sectionType {
        case .characters:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterCell else { return UICollectionViewCell() }
            cell.configure(image: characters[indexPath.row].image)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension EpisodesDetailsViewController: UICollectionViewDelegateFlowLayout {

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
        detailViewController.setCharacter(data: characters[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

