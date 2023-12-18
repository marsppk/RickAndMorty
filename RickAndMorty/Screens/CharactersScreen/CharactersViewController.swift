//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 25.10.2023.
//

import UIKit
import CoreText

class CharactersViewController: UIViewController {
    
    // MARK: - Constants

    private enum Constant {
        enum Collection {
            static let cellHeight = 200.0
            static let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            static let lineSpacing = 16.0
            static let interitemSpacing = 4.0
        }
        enum API {
            static let delay = 0.2
        }
        enum Indicator {
            static let height = 50.0
            static let offset = 110.0
        }
        enum Pages {
            static let amount = 42
        }
    }

    private enum MainSection: Int, CaseIterable {
        case main
    }

    // MARK: - Properties

    private var data: [Character] = []
    private var workItem: DispatchWorkItem?
    private var apiManager = APIManager()
    private var page = 1

    // MARK: - Subviews

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CharactersCollectionCell.self, forCellWithReuseIdentifier: CharactersCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = []
        page = 1
        collectionView.reloadData()
        activityIndicatorView.style = .large
        activityIndicatorView.center = view.center
        getCharacters(page: page)
        page += 1
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        workItem?.cancel()
    }
    
    // MARK: - Methods
    
    private func getCharacters(page: Int) {
        activityIndicatorView.startAnimating()

        workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }

            self.apiManager.getCharacters(page: page) { [weak self] characters in
                guard let self = self else { return }
                self.getImages(characters: characters)
            }
        }

        if let item = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + Constant.API.delay, execute: item)
        }
    }
    
    private func getImages(characters: [NetworkingCharacter]) {
        var fetchedImagesCount = 0
        var newCharacters: [Character] = []
        
        for character in characters {
            self.apiManager.getImage(characterImage: character.image) { [weak self] imageData in
                guard let self = self else { return }
                self.getEpisodesForCharacter(character: character) { episodes in
                    fetchedImagesCount += 1
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
                    newCharacters.append(newCharacter)
                    
                    if fetchedImagesCount == characters.count {
                        self.data.append(contentsOf: newCharacters)
                        self.data = self.data.sorted { $0.id < $1.id }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.stopIndicator()
                        }
                    }
                }
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
    
    private func stopIndicator() {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - Constant.Indicator.offset, width: UIScreen.main.bounds.width, height: Constant.Indicator.height)
        activityIndicatorView.style = .medium
    }
    
    private func configureUI() {
        title = "Characters"
        view.backgroundColor = Appearance.bgImage
        
        let navigationBarAppearance = Appearance.NavBarAppearance()
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = false
        
        [collectionView, activityIndicatorView].forEach() {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

extension CharactersViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        MainSection.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = MainSection.allCases[section]

        switch sectionType {
        case .main:
            return data.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let section = MainSection.allCases[indexPath.section]

        switch section {
        case .main:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharactersCollectionCell.identifier,
                for: indexPath
            ) as? CharactersCollectionCell else { return UICollectionViewCell() }

            cell.configure(image: data[indexPath.item].image, name: data[indexPath.item].name)

            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CharactersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.Collection.cellHeight - 40, height: Constant.Collection.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        Constant.Collection.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constant.Collection.interitemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constant.Collection.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 && page <= Constant.Pages.amount {
            getCharacters(page: page)
            page += 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = CharactersDetailsViewController()
        detailViewController.setCharacter(data: data[indexPath.row])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

