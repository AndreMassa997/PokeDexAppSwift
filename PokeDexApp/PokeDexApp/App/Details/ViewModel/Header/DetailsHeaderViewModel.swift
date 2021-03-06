//
//  DetailsHeaderViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 28/02/21.
//

import UIKit

struct DetailsHeaderViewModel{
    let carouselViewModel: CarouselViewModel
    
    let name: String
    let types: [Type]?
    let id: Int
   
    init(pokemonModel: PokemonModel){
        self.types = pokemonModel.types?.compactMap{ type in
            type.type
        }
        self.name = pokemonModel.name
        self.id = pokemonModel.id
        
        let urls = [
        pokemonModel.sprites?.other?.officialArtwork?.frontDefault,
            pokemonModel.sprites?.backDefault,
            pokemonModel.sprites?.backFemale,
            pokemonModel.sprites?.backShiny,
            pokemonModel.sprites?.backShinyFemale,
            pokemonModel.sprites?.frontDefault,
            pokemonModel.sprites?.frontFemale,
            pokemonModel.sprites?.frontShiny,
            pokemonModel.sprites?.frontShinyFemale,
        ].compactMap { $0 }
        
        self.carouselViewModel = CarouselViewModel(urls: urls, mainColor: pokemonModel.types?.first?.type.name.mainColor ?? .clear)
    }
    
    func getPokemonId() -> String {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        return formatter.string(from: NSNumber(value: self.id)) ?? ""
    }
}

struct CarouselViewModel{
    let urls: [URL]
    let mainColor: UIColor
}
