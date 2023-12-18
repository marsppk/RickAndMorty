//
//  Separator.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 07.12.2023.
//

import UIKit

class Separator: UIView {
    init() {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupUI() {
        self.backgroundColor = .lightGray

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
