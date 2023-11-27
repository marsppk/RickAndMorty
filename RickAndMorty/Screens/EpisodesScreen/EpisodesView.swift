//
//  EpisodesView.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 19.11.2023.
//

import UIKit

protocol EpisodesViewDelegate: AnyObject {
    func getEpisodes()
}

class EpisodesView: UIView {
    
    // MARK: - Properties
    
    private weak var delegate: EpisodesViewDelegate?
    
    // MARK: - Subviews
    
    private let tableView: EpisodesTableView = {
        let tableView = EpisodesTableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = self.center
        indicator.hidesWhenStopped = true
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    
    init(delegate: EpisodesViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func getData() {
        activityIndicatorView.startAnimating()
        delegate?.getEpisodes()
    }
    
    func changeTableViewData(data: [Int:[Episode]]) {
        tableView.updateData(data: data)
        tableView.reloadData()
        activityIndicatorView.stopAnimating()
    }
}


extension EpisodesView: EpisodesViewControllerDelegate {
    func setupView() {
        self.backgroundColor = Appearance.bgImage
        changeTableViewData(data: [:])
        getData()
        
        [tableView, activityIndicatorView].forEach {
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -5),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5),
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: 50),
            activityIndicatorView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

