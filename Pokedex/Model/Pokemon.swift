//
//  Pokemon.swift
//  Pokedex
//
//  Created by 이은재 on 2023/08/31.
//

import Foundation

struct PokedexResponse: Codable, Hashable {
    let count: Int
    let next: String
    
    struct PokedexResult: Codable, Hashable {
        let name: String
        let url: String
    }
    let results: [PokedexResult]
}

// MARK: - Pokemon
struct Pokemon: Codable, Hashable {
    let height, id: Int
    let name: String
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
    
    var imageUrl: String {
        return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png"
    }
    
    var tag: String {
        return String(format: "#%04d", id)
    }
}

struct StatClass: Codable, Hashable {
    let name: String
    let url: String
}

struct Stat: Codable, Hashable {
    let baseStat, effort: Int
    let stat: StatClass

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort, stat
    }
}

struct TypeElement: Codable, Hashable {
    let slot: Int
    let type: StatClass
}
