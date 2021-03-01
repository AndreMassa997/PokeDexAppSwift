//
//  EvolutionViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 01/03/21.
//

import Foundation

final class EvolutionViewModel{
    let basePokemonName: String
    let basePokemonImageURL: URL?
    let evolutionLevel: Int
    let toPokemonName: String
    let toPokemonImageURL: URL?
    
    init(basePokemon: PokemonModel, toPokemon: PokemonModel, evolutionLevel: Int) {
        self.basePokemonImageURL = basePokemon.sprites?.other?.officialArtwork?.frontDefault
        self.basePokemonName = basePokemon.name
        self.toPokemonImageURL = toPokemon.sprites?.other?.officialArtwork?.frontDefault
        self.toPokemonName = toPokemon.name
        self.evolutionLevel = evolutionLevel
    }
}
