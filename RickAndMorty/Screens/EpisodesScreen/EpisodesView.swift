//
//  EpisodesView.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 19.11.2023.
//

import UIKit

protocol EpisodesViewDelegate: AnyObject {
    func getEpisodes()
    func openModalScreen(item: EpisodesDetailsViewController)
}

class EpisodesView: UIView {
    
    // MARK: - Properties
    
    private weak var delegate: EpisodesViewDelegate?
    private var data: [Int:[Episode]] = [:]
    
    // MARK: - Subviews
    
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
        self.data = data
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

extension EpisodesView: UITableViewDelegate {
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
        headerLabel.text = "Season " + String(section + 1)
        headerLabel.textColor = UIColor.lightGray
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)
        
        headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        return headerView
    }
}

// MARK: - UITableViewDataSource

extension EpisodesView: UITableViewDataSource {
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
        cell.textLabel?.font = UIFont(name: "WubbaLubbaDubDubRegular", size: 26)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = EpisodesDetailsViewController()
        let item = data[indexPath.section + 1]
        detailViewController.setEpisode(data: item?[indexPath.row])
        delegate?.openModalScreen(item: detailViewController)
    }
}


