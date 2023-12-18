//
//  LocationsView.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.11.2023.
//

import UIKit

protocol LocationsViewDelegate: AnyObject {
    func openModalScreen(item: LocationsDetailsViewController)
}

class LocationsView: UIView {
    
    // MARK: - Subviews
    
    private var data: [String:[Location]] = [:]
    
    private weak var delegate: LocationsViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
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
    
    init(delegate: LocationsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func changeTableViewData(data: [String:[Location]]) {
        self.data = data
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

// MARK: - UITableViewDelegate

extension LocationsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.font = UIFont(name: "TheSadTrain-Regular", size: 30)
        let locations = Array(data.keys)
        let sortedLocations = locations.sorted { $0 < $1 }
        headerLabel.text = sortedLocations[section].capitalized
        headerLabel.textColor = UIColor.lightGray
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}

// MARK: - UITableViewDataSource

extension LocationsView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let locations = Array(data.keys)
        let sortedLocations = locations.sorted { $0 < $1 }
        return data[sortedLocations[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let locations = Array(data.keys)
        let sortedLocations = locations.sorted { $0 < $1 }
        let sectionName = sortedLocations[indexPath.section]
        cell.backgroundColor = UIColor(named: "labelBG")?.withAlphaComponent(0.7)
        cell.textLabel?.text = data[sectionName]?[indexPath.row].name
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: "WubbaLubbaDubDubRegular", size: 26)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = LocationsDetailsViewController()
        let locations = Array(data.keys)
        let sortedLocations = locations.sorted { $0 < $1 }
        let item = data[sortedLocations[indexPath.section]]
        if let item {
            detailViewController.setLocation(data: item[indexPath.row])
            delegate?.openModalScreen(item: detailViewController)
        }
    }
}
