//
//  Locations.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.11.2023.
//

import Foundation

struct Locations: Codable {
    let info: InfoLocations
    let results: [NetworkingLocation]
}

