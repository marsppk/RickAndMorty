//
//  Episodes.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 19.11.2023.
//

import Foundation

struct Episodes: Codable {
    let info: InfoEpisode
    let results: [NetworkingEpisode]
}
