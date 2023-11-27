//
//  InfoLocations.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.11.2023.
//

import Foundation

struct InfoLocations: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
