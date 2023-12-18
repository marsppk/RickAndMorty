//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 07.12.2023.
//

import UIKit

final class CharacterCell: UICollectionViewCell {

    // MARK: Constant

    private enum Constant {
        enum ContentView {
            static let radius = 12.0
        }
        enum ImageView {
            static let radius = 12.0
        }
    }

    // MARK: - Identifier

    static let identifier = "CharacterCell"

    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constant.ImageView.radius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        imageView.image = nil
    }

    // MARK: - Methods

    func configure(image: UIImage?) {
        imageView.image = image
    }

    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constant.ContentView.radius
        
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
