//
//  LocationsTableView.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 27.11.2023.
//

import UIKit
import Foundation

class LocationsTableView: UITableView {
    
    // MARK: - Properties
    
    private var data: [String:[Location]] = [:]
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero, style: .insetGrouped)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func updateData(data: [String:[Location]]) {
        self.data = data
    }
}

// MARK: - UITableViewDelegate

extension LocationsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

// MARK: - UITableViewDataSource

extension LocationsTableView: UITableViewDataSource {
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let locations = Array(data.keys)
        let sortedLocations = locations.sorted { $0 < $1 }
        return sortedLocations[section]
    }
}
