//
//  EpisodeCell.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 06.12.2023.
//

import UIKit

final class EpisodeCell: UICollectionViewCell {

    // MARK: Constant

    private enum Constant {
        enum TitleLabel {
            static let numberOfLines = 0
        }
        enum ContentView {
            static let radius = 12.0
        }
        enum Colors {
            static let labelBG = UIColor(named: "labelBG")!
        }
    }

    // MARK: - Identifier

    static let identifier = "CollectionCell"

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = Constant.TitleLabel.numberOfLines
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GetSchwifty-Regular", size: 20)
        label.textColor = UIColor(named: "labels")
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    // MARK: - Methods

    func configure(name: String) {
        titleLabel.text = name
    }

    private func configureUI() {
        contentView.backgroundColor = Constant.Colors.labelBG
        contentView.layer.cornerRadius = Constant.ContentView.radius
        
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
        ])
    }
}

