//
//  PokemonModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

// MARK: - PokemonModel
struct PokemonModel: Decodable {
    let id: Int
    let name: String
    
    //height in decimeters
    let height: Int?
    //weight in hectograms
    let weight: Int?
    
    let abilities: [Ability]?
    let sprites: Sprites?
    let stats: [Stats]?
    let types: [TypeElement]?
}

// MARK: Ability
struct Ability: Decodable{
    let ability: Result
    let isHidden: Bool
}

struct Result: Decodable{
    let name: String
}

//Pokemon Images
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
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Decodable {
    let frontDefault: URL?
}

//Pokemon Stats
// MARK: - Stats
struct Stats: Decodable {
    let baseStat: Int?
    let effort: Int?
    let stat: Stat
}

// MARK: - Stat
struct Stat: Decodable {
    let name: StatName
}

enum StatName: String, Decodable{
    case hp
    case attack
    case defense
    case specialAttack = "special-attack"
    case specialDefense = "special-defense"
    case speed

    var name: String{
        switch self {
        case .hp:
            return "HP"
        case .attack:
            return "ATK"
        case .defense:
            return "DEF"
        case .specialAttack:
            return "SATK"
        case .specialDefense:
            return "SDEF"
        case .speed:
            return "SPD"
        }
    }
    
    //max values are available from https://www.serebii.net/pokedex-swsh/stat/sp-attack.shtml
    var maxValue: Float{
        switch self {
        case .hp:
            return 255
        case .attack:
            return 181
        case .defense:
            return 230
        case .specialAttack:
            return 173
        case .specialDefense:
            return 230
        case .speed:
            return 200
        }
    }
    
}

// MARK: - TypeElement
struct TypeElement: Decodable {
    let type: Type
}

// MARK: - Type
struct Type: Decodable {
    let name: PokemonType
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
    
    //get official pokemon colors from https://wiki.pokemoncentral.it/Tipo
    var mainColor: UIColor {
        switch self {
        case .normal:
            return #colorLiteral(red: 0.5716369748, green: 0.6002758145, blue: 0.6475561261, alpha: 1)
        case .fighting:
            return #colorLiteral(red: 0.880083859, green: 0.1892808676, blue: 0.3863664269, alpha: 1)
        case .flying:
            return #colorLiteral(red: 0.5495741367, green: 0.6584999561, blue: 0.8765556812, alpha: 1)
        case .poison:
            return #colorLiteral(red: 0.7127818465, green: 0.3641316593, blue: 0.8076178432, alpha: 1)
        case .ground:
            return #colorLiteral(red: 0.9211483002, green: 0.4423263669, blue: 0.2223921418, alpha: 1)
        case .rock:
            return #colorLiteral(red: 0.7886140943, green: 0.709207356, blue: 0.5137671232, alpha: 1)
        case .bug:
            return #colorLiteral(red: 0.5278400779, green: 0.7478100657, blue: 0, alpha: 1)
        case .ghost:
            return #colorLiteral(red: 0.3072502315, green: 0.413003087, blue: 0.7028397918, alpha: 1)
        case .steel:
            return #colorLiteral(red: 0.2502724528, green: 0.5344678164, blue: 0.6258850098, alpha: 1)
        case .fire:
            return #colorLiteral(red: 1, green: 0.5929041505, blue: 0.2348099649, alpha: 1)
        case .water:
            return #colorLiteral(red: 0.2218952477, green: 0.6230598092, blue: 0.8972640038, alpha: 1)
        case .grass:
            return #colorLiteral(red: 0.1684704125, green: 0.7559096813, blue: 0.2590118647, alpha: 1)
        case .electric:
            return #colorLiteral(red: 0.9490627646, green: 0.8404652476, blue: 0, alpha: 1)
        case .psychic:
            return #colorLiteral(red: 1, green: 0.4060875177, blue: 0.4327207804, alpha: 1)
        case .ice:
            return #colorLiteral(red: 0.2953563631, green: 0.8154250383, blue: 0.7444574237, alpha: 1)
        case .dragon:
            return #colorLiteral(red: 0, green: 0.4185396433, blue: 0.8112379909, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.355060488, green: 0.3440642953, blue: 0.3920295835, alpha: 1)
        case .fairy:
            return #colorLiteral(red: 0.9902945161, green: 0.5258321166, blue: 0.9177828431, alpha: 1)
        case .shadow:
            return #colorLiteral(red: 0.2507422864, green: 0.2035931051, blue: 0.3424940407, alpha: 1)
        case .unknown:
            return #colorLiteral(red: 0.2782413363, green: 0.4239462614, blue: 0.3825690746, alpha: 1)
        }
    }
    
    var endColor: UIColor {
        switch self {
        case .normal:
            return #colorLiteral(red: 0.5716369748, green: 0.6002758145, blue: 0.6475561261, alpha: 1)
        case .fighting:
            return #colorLiteral(red: 0.9739872813, green: 0.1754835248, blue: 0.2562509775, alpha: 1)
        case .flying:
            return #colorLiteral(red: 0.6187397838, green: 0.7536559701, blue: 0.9586126208, alpha: 1)
        case .poison:
            return #colorLiteral(red: 0.8102468848, green: 0.3396695852, blue: 0.8522182107, alpha: 1)
        case .ground:
            return #colorLiteral(red: 0.8652047515, green: 0.5614356995, blue: 0.342061609, alpha: 1)
        case .rock:
            return #colorLiteral(red: 0.8462945819, green: 0.7972704768, blue: 0.5281767249, alpha: 1)
        case .bug:
            return #colorLiteral(red: 0.6490378976, green: 0.7893058062, blue: 0, alpha: 1)
        case .ghost:
            return #colorLiteral(red: 0.4711506367, green: 0.4411643147, blue: 0.8536420465, alpha: 1)
        case .steel:
            return #colorLiteral(red: 0.2158685029, green: 0.6516324282, blue: 0.6685814261, alpha: 1)
        case .fire:
            return #colorLiteral(red: 1, green: 0.665902853, blue: 0.1286484301, alpha: 1)
        case .water:
            return #colorLiteral(red: 0.2920359969, green: 0.732037127, blue: 0.9077424407, alpha: 1)
        case .grass:
            return #colorLiteral(red: 0.07089930028, green: 0.7674418092, blue: 0.4301987886, alpha: 1)
        case .electric:
            return #colorLiteral(red: 1, green: 0.8867517114, blue: 0.3580238521, alpha: 1)
        case .psychic:
            return #colorLiteral(red: 0.9490309358, green: 0.4241904616, blue: 0.4450967908, alpha: 1)
        case .ice:
            return #colorLiteral(red: 0.4338750839, green: 0.8733255863, blue: 0.8287960291, alpha: 1)
        case .dragon:
            return #colorLiteral(red: 0, green: 0.501458168, blue: 0.8041072488, alpha: 1)
        case .dark:
            return #colorLiteral(red: 0.3428039551, green: 0.3115460575, blue: 0.3858483136, alpha: 1)
        case .fairy:
            return #colorLiteral(red: 1, green: 0.6250781417, blue: 0.9216451049, alpha: 1)
        case .shadow:
            return #colorLiteral(red: 0.3721669614, green: 0.307719171, blue: 0.5072653294, alpha: 1)
        case .unknown:
            return #colorLiteral(red: 0.4000579417, green: 0.6141328812, blue: 0.5543600917, alpha: 1)
        }
    }
    
    var image: UIImage?{
        UIImage(named: rawValue)
    }
    
}
