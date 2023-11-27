//
//  LocationsView.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.11.2023.
//

import UIKit

class LocationsView: UIView {
    
    // MARK: - Subviews
    
    private let tableView: LocationsTableView = {
        let tableView = LocationsTableView()
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
    
    // MARK: - Methods
    
    func changeTableViewData(data: [String:[Location]]) {
        tableView.updateData(data: data)
        tableView.reloadData()
        if !data.isEmpty {
            activityIndicatorView.stopAnimating()
        }
    }
}


extension LocationsView: LocationsViewControllerDelegate {
    func setupView() {
        self.backgroundColor = Appearance.bgImage
        activityIndicatorView.startAnimating()
        
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

