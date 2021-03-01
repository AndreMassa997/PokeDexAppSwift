//
//  MainViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

final class MainViewModel{
    var coordinator: MainCoordinator?
    private(set) var pokemons: [PokemonViewModel] = []
    private(set) var nextOffset: Int = 0
    
    enum MainCollectionViewCell: Int{
        case search
        case pokemon
        case loader
        case label
    }
    
    init(with coordinator: MainCoordinator){
        self.coordinator = coordinator
    }
    
    public func getPokemons(offset: Int, onSuccess: (() -> Void)?){
        self.coordinator?.getPokemons(offset: offset, onSuccess: { [weak self] mainModel, pokemons in
            self?.pokemons.append(contentsOf: pokemons)
            if let nextUrl = mainModel.next, let nextOffsetString = nextUrl.getQueryStringParameter(param: "offset"), let nextOffset = Int(nextOffsetString){
                self?.nextOffset = nextOffset
            }
            onSuccess?()
        })
    }

    //pokemon from list tapped
    public func didSelectPokemon(pokemon: PokemonViewModel){
        coordinator?.showPokemonDetails(pokemon: pokemon)
    }
    
}
