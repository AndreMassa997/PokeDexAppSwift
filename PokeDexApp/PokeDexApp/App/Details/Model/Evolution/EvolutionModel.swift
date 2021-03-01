//
//  EvolutionModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 01/03/21.
//

import Foundation

struct EvolutionModel: Decodable{
    let chain: EvolutionChain
}

struct EvolutionChain: Decodable {
    let evolutionDetails: [EvolutionDetail]
    let evolvesTo: [EvolutionChain]
    let species: ResultModel
}

struct EvolutionDetail: Decodable {
    let minLevel: Int
}
