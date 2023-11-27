//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.10.2023.
//

import UIKit

protocol EpisodesViewControllerDelegate: AnyObject {
    func setupView()
}

class EpisodesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var data: [Int:[Episode]] = [:]
    private var workItem: DispatchWorkItem?
    private var apiManager = APIManager()
    private weak var delegate: EpisodesViewControllerDelegate?
    
    // MARK: - Subviews
    
    private lazy var contentView = EpisodesView(delegate: self)

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        delegate = contentView
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = [:]
        delegate?.setupView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configurateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        workItem?.cancel()
    }
    
    // MARK: - Methods

    func configurateUI() {
        title = "Epizodes"
        let navigationBarAppearance = Appearance.NavBarAppearance()
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }
}

// MARK: - EpisodesViewDelegate

extension EpisodesViewController: EpisodesViewDelegate {
    func getEpisodes() {
        workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            for page in 1...3 {
                var fetchedEpisodesCount = 0
                self.apiManager.getEpisodes(page: page) { [weak self] episodes in
                    guard let self = self else { return }
                    for elem in episodes {
                        let indexWithS = String(elem.episode.prefix(3))
                        let indexWithoutS = Int(indexWithS.suffix(2))
                        fetchedEpisodesCount += 1
                        let new = Episode(
                            id: elem.id,
                            name: elem.name,
                            airDate: elem.airDate,
                            episode: elem.episode,
                            characters: elem.characters,
                            url: elem.url,
                            created: elem.created
                        )
                        if let index = indexWithoutS {
                            if self.data[index] != nil {
                                self.data[index]?.append(new)
                            }
                            else {
                                self.data[index] = [new]
                            }
                        }
                    }
                    if fetchedEpisodesCount == episodes.count && page == 3 {
                        DispatchQueue.main.async {
                            self.contentView.changeTableViewData(data: self.data)
                        }
                    }
                }
            }
        }
        if let item = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: item)
        }
    }
}
