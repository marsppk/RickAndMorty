//
//  InfoCharacters.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 28.10.2023.
//

import Foundation

// MARK: - Info

struct InfoCharacters: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
