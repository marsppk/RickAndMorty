//
//  EpisodesTableView.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 22.11.2023.
//

import UIKit

class EpisodesTableView: UITableView {
    
    // MARK: - Properties
    
    private var data: [Int:[Episode]] = [:]
    
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
    
    func updateData(data: [Int:[Episode]]) {
        self.data = data
    }
}

// MARK: - UITableViewDelegate

extension EpisodesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

// MARK: - UITableViewDataSource

extension EpisodesTableView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section + 1]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = data[indexPath.section + 1]
        cell.backgroundColor = UIColor(named: "labelBG")?.withAlphaComponent(0.7)
        cell.textLabel?.text = item?[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Season " + String(section + 1)
    }
}
