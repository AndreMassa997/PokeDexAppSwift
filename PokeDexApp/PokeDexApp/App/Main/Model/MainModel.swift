//
//  MainModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

// MARK: - MainModel
struct MainModel: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [ResultModel]?
}

// MARK: - ResultModel
struct ResultModel: Decodable {
    let name: String?
    let url: URL?
}

//Data for single pokemon cell
struct PokemonCellModel{
    let name: String
    let type: PokemonType?
    let imageURL: URL?
    let id: Int
    
    init(pokemonModel: PokemonModel){
        self.id = pokemonModel.id
        self.name = pokemonModel.name
        self.type = pokemonModel.types?.first?.type.name
        self.imageURL = pokemonModel.sprites?.other?.officialArtwork?.frontDefault ?? pokemonModel.sprites?.other?.dreamWorld?.frontDefault
    }
}
