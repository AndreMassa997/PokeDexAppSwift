//
//  DetailsHeaderViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 28/02/21.
//

import UIKit

final class DetailsHeaderViewModel{
    private let detailsHeaderModel: DetailHeaderModel
    let carouselViewModel: CarouselViewModel

    init(pokemonModel: PokemonModel){
        let types: [Type]? = pokemonModel.types?.compactMap{ type in
            type.type
        }
        self.detailsHeaderModel = DetailHeaderModel(name: pokemonModel.name, types: types)
        
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
        
        self.carouselViewModel = CarouselViewModel(carouselModel: CarouselModel(urls: urls, mainColor: pokemonModel.types?.first?.type.name.mainColor ?? .clear))
    }
    
    func getPokemonName() -> String{
        self.detailsHeaderModel.name
    }
    
    func getTypes() -> [Type]?{
        self.detailsHeaderModel.types
    }
}

final class CarouselViewModel{
    private let carouselModel: CarouselModel

    init(carouselModel: CarouselModel){
        self.carouselModel = carouselModel
    }
    
    func getUrls() -> [URL]{
        self.carouselModel.urls
    }
    
    func getMainColor() -> UIColor{
        self.carouselModel.mainColor
    }
}
