//
//  InfoEpisode.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 19.11.2023.
//

import Foundation

struct InfoEpisode: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
