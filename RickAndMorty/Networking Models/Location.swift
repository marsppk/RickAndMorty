//
//  Location.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 28.10.2023.
//

import Foundation

// MARK: - Location

struct Location: Codable {
    let name: String
    let url: String
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

