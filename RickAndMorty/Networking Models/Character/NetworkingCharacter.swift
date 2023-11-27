//
//  NetworkingCharacter.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 28.10.2023.
//

import Foundation

// MARK: - NetworkingCharacter

struct NetworkingCharacter: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin, location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
