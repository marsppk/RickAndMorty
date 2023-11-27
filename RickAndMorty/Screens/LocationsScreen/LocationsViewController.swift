//
//  LocationsViewController.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.10.2023.
//

import Combine
import UIKit

protocol LocationsViewControllerDelegate: AnyObject {
    func setupView()
}

class LocationsViewController: UIViewController {
    
    // MARK: - Constants
    
    private let viewModel = LocationsViewModel()
    
    // MARK: - Properties

    private weak var delegate: LocationsViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subviews
    
    private lazy var contentView = LocationsView()

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        delegate = contentView
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.setData(data: [:])
        delegate?.setupView()
        viewModel.getLocations()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configurateUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelWorkItem()
    }
    
    // MARK: - Methods

    private func configurateUI() {
        title = "Locations"
        let navigationBarAppearance = Appearance.NavBarAppearance()
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func bind() {
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.contentView.changeTableViewData(data: data)
            }
            .store(in: &cancellables)
    }
}

