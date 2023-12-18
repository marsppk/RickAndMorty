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
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

// MARK: - EpisodesViewDelegate

extension EpisodesViewController: EpisodesViewDelegate {
    
    func openModalScreen(item: EpisodesDetailsViewController) {
        navigationController?.pushViewController(item, animated: true)
    }
    
    func getEpisodes() {
        let dispatchGroup = DispatchGroup()
        var newData: [Int: [Episode]] = [:]
        
        for page in 1...3 {
            dispatchGroup.enter()
            self.apiManager.getEpisodes(page: page) { episodes in
                for elem in episodes {
                    let indexWithS = String(elem.episode.prefix(3))
                    let indexWithoutS = Int(indexWithS.suffix(2))
                    let newEpisode = Episode(
                        id: elem.id,
                        name: elem.name,
                        airDate: elem.airDate,
                        episode: elem.episode,
                        characters: elem.characters,
                        url: elem.url,
                        created: elem.created
                    )
                    if let index = indexWithoutS {
                        if newData[index] != nil {
                            newData[index]?.append(newEpisode)
                        } else {
                            newData[index] = [newEpisode]
                        }
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.data = newData
                self.contentView.changeTableViewData(data: self.data)
            }
        }
    }
}
