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
            static let delay = 3.0
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
    var apiManager = APIManager()
    var page = 1

    // MARK: - Subviews

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
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
        getCharacters(page: page)
        page += 1
    }
    
    // MARK: - Methods
    
    private func getCharacters(page: Int) {
        activityIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + Constant.API.delay) {
            self.apiManager.getCharacters(page: page) { [weak self] characters in
                guard let self else { return }
                for character in characters {
                    getImage(character: character)
                }
            }
        }
    }
    
    private func getImage(character: Result) {
        self.apiManager.getImage(character: character) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                let newCharacter = Character(
                    id: character.id,
                    name: character.name,
                    status: character.status,
                    species: character.species,
                    type: character.type,
                    gender: character.gender,
                    origin: character.origin,
                    location: character.location,
                    image: UIImage(data: image),
                    episode: character.episode,
                    url: character.url,
                    created: character.created
                )
                self.data.append(newCharacter)
                self.collectionView.reloadData()
                self.stopIndicator()
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
                withReuseIdentifier: CollectionCell.identifier,
                for: indexPath
            ) as? CollectionCell else { return UICollectionViewCell() }

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
}

