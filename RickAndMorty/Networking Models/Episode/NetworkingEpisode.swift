//
//  NetworkingEpisode.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 19.11.2023.
//

import Foundation

struct NetworkingEpisode: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
