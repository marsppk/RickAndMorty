//
//  CollectionCell.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.10.2023.
//

import UIKit

final class CollectionCell: UICollectionViewCell {

    // MARK: Constant

    private enum Constant {
        enum TitleLabel {
            static let leading = 16.0
            static let trailing = 16.0
            static let radius = 8.0
            static let height = 40.0
            static let width = -2
            static let numberOfLines = 2
        }
        enum ContentView {
            static let radius = 12.0
        }
        enum ImageView {
            static let radius = 12.0
        }
        enum Font {
            static let font = UIFont(name: "WubbaLubbaDubDubRegular", size: 20)
        }
        enum Colors {
            static let labelBG = UIColor(named: "labelBG")!
            static let stroke = UIColor(named: "strokeColor")
            static let foreground = UIColor(named: "foregroundColor")
        }
    }

    // MARK: - Identifier

    static let identifier = "CollectionCell"

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        label.layer.cornerRadius = Constant.TitleLabel.radius
        label.numberOfLines = Constant.TitleLabel.numberOfLines
        label.backgroundColor = Constant.Colors.labelBG
        label.font = Constant.Font.font
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.layer.cornerRadius = Constant.ImageView.radius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = Constant.Colors.labelBG.cgColor
        imageView.layer.borderWidth = 3.0
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
        titleLabel.text = nil
        imageView.image = nil
    }

    // MARK: - Methods

    func configure(image: UIImage?, name: String) {
        let text = name
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: Constant.Colors.stroke!,
            .foregroundColor: Constant.Colors.foreground!,
            .strokeWidth: Constant.TitleLabel.width,
        ]
        titleLabel.attributedText = NSAttributedString(string: text, attributes: strokeTextAttributes)
        imageView.image = image
    }

    private func configureUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Constant.ContentView.radius
        contentView.layer.shadowColor = UIColor.white.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 3.0
        
        [imageView, titleLabel].forEach() {
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constant.TitleLabel.height)
        ])
    }
}
