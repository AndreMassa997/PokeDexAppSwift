//
//  PokemonViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 01/03/21.
//

import Foundation

//Data for single pokemon cell
struct PokemonCellViewModel{
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
    
    func getPokemonId() -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        return formatter.string(from: NSNumber(value: self.id)) ?? ""
    }
}
