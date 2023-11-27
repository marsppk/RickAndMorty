//
//  NetworkingLocation.swift
//  RickAndMorty
//
//  Created by Maria Slepneva on 26.11.2023.
//

import Foundation

struct NetworkingLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
