//
//  MainViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

final class MainViewModel{
    var coordinator: MainCoordinator?
    private(set) var pokemons: [PokemonCellViewModel] = []
    private(set) var filtered: [PokemonCellViewModel] = []
    private(set) var nextOffset: Int = 0
    private(set) var isSearching: Bool = false
    
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
    func didSelectPokemon(pokemon: PokemonCellViewModel){
        coordinator?.showPokemonDetails(pokemon: pokemon)
    }
    
    func searchPokemon(text: String, onSuccess: (()->Void)?, onError: (()->Void)?){
        coordinator?.searchPokemonLocally(text: text, onSuccess: { [weak self] pokemons in
            self?.isSearching = true
            self?.pokemons = pokemons
            onSuccess?()
        }, onError: {
            
        })
    }
    
    
    
}
