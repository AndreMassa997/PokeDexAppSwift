//
//  PokemonModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation
import UIKit

// MARK: - PokemonModel
struct PokemonModel: Decodable {
    let id: Int
    let name: String
    let height: Int?
    let weight: Int?
    let sprites: Sprites?
    let stats: [Stats]?
    let types: [TypeElement]?
}

// MARK: - Sprites
struct Sprites: Decodable {
    let backDefault: URL?
    let backFemale: URL?
    let backShiny: URL?
    let backShinyFemale: URL?
    let frontDefault: URL?
    let frontFemale: URL?
    let frontShiny: URL?
    let frontShinyFemale: URL?
    let other: Other?
}

// MARK: - Other
struct Other: Decodable {
    let dreamWorld: DreamWorld?
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dreamWorld"
        case officialArtwork = "official-artwork"
    }
}

// MARK: - DreamWorld
struct DreamWorld: Decodable {
    let frontDefault: URL?
    let frontFemale: URL?
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Decodable {
    let frontDefault: URL?
}

// MARK: - Stats
struct Stats: Decodable {
    let baseStat: Int?
    let effort: Int?
    let stat: Stat
}

// MARK: - Stat
struct Stat: Decodable {
    let name: String
    let url: URL
}

// MARK: - TypeElement
struct TypeElement: Decodable {
    let slot: Int
    let type: Type
}

// MARK: - Type
struct Type: Decodable {
    let name: PokemonType
    let url: URL
}

//get all types from: https://pokeapi.co/api/v2/type
enum PokemonType: String, Decodable {
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    case unknown
    case shadow
    
    //get official pokemon colors from https://wiki.pokemoncentral.it/
    func color() -> UIColor {
        switch self {
        case .normal:
            return #colorLiteral(red: 0.5470016599, green: 0.5810818076, blue: 0.6109013557, alpha: 1)
        case .fighting:
            return #colorLiteral(red: 0.7882104516, green: 0.2428354025, blue: 0.4018281698, alpha: 1)
        case .flying:
            return #colorLiteral(red: 0.5387618542, green: 0.6427439451, blue: 0.8565696478, alpha: 1)
        case .poison:
            return #colorLiteral(red: 0.6553355455, green: 0.4089289308, blue: 0.7780326009, alpha: 1)
        case .ground:
            return #colorLiteral(red: 0.8289013505, green: 0.4496176243, blue: 0.2513646185, alpha: 1)
        case .rock:
            return #colorLiteral(red: 0.7535194755, green: 0.6981111765, blue: 0.5252377987, alpha: 1)
        case .bug:
            return #colorLiteral(red: 0.5493260622, green: 0.7307934165, blue: 0.1643458307, alpha: 1)
        case .ghost:
            return #colorLiteral(red: 0.3100687563, green: 0.4014959931, blue: 0.6659750938, alpha: 1)
        case .steel:
            return #colorLiteral(red: 0.3447906971, green: 0.5452088714, blue: 0.6202380061, alpha: 1)
        case .fire:
            return #colorLiteral(red: 0.9765924811, green: 0.5927538872, blue: 0.3088889122, alpha: 1)
        case .water:
            return #colorLiteral(red: 0.2954151034, green: 0.5502636433, blue: 0.8214174509, alpha: 1)
        case .grass:
            return #colorLiteral(red: 0.3756253123, green: 0.721344173, blue: 0.3435608149, alpha: 1)
        case .electric:
            return #colorLiteral(red: 0.9248973727, green: 0.795854032, blue: 0.2178544104, alpha: 1)
        case .psychic:
            return #colorLiteral(red: 0.9490309358, green: 0.4241904616, blue: 0.4450967908, alpha: 1)
        case .ice:
            return #colorLiteral(red: 0.4311455488, green: 0.789681673, blue: 0.7284545302, alpha: 1)
        case .dragon:
            return #colorLiteral(red: 0.04432298988, green: 0.4193534553, blue: 0.7448943257, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.3428039551, green: 0.3115460575, blue: 0.3858483136, alpha: 1)
        case .fairy:
            return #colorLiteral(red: 0.9011231065, green: 0.5376293063, blue: 0.8814260364, alpha: 1)
        case .shadow:
            return #colorLiteral(red: 0.3643115163, green: 0.2998460233, blue: 0.4993721843, alpha: 1)
        case .unknown:
            return #colorLiteral(red: 0.3985958099, green: 0.6181690097, blue: 0.5583426952, alpha: 1)
        }
    }
}
