//
//  DetailsModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 01/03/21.
//

import Foundation

struct PokemonSpecies: Decodable{
    let evolutionChain: SpeciesEvolutionChain
    let flavorTextEntries: [FlavorTextEntry]
}

struct SpeciesEvolutionChain: Decodable{
    let url: URL
}

struct FlavorTextEntry: Decodable{
    let flavorText: String
    let language: ResultModel
}
