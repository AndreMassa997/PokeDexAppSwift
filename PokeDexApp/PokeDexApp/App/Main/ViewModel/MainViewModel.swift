//
//  MainViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

final class MainViewModel{
    private let coordinator: MainCoordinator
    private(set) var pokemonCells: [PokemonCellViewModel] = []
    private var pokemons: [PokemonModel] = []
    private var pokemonFounded: PokemonModel?
    private(set) var nextOffset: Int = 0
    private(set) var isSearching: Bool = false
    
    init(with coordinator: MainCoordinator){
        self.coordinator = coordinator
    }
    
    //MARK: PUBLIC METHODS
    func getPokemons(onSuccess: (() -> Void)?, onError: (()-> Void)?){
        self.coordinator.getPokemons(offset: nextOffset, onSuccess: { [weak self] mainModel, pokemons in
            self?.pokemons.append(contentsOf: pokemons)
            self?.pokemonCells.append(contentsOf: pokemons.map({
                PokemonCellViewModel(pokemonModel: $0)
            }))
            self?.pokemonCells.sort(by: { $0.id < $1.id })
            
            if let nextUrl = mainModel.next, let nextOffsetString = nextUrl.getQueryStringParameter(param: "offset"), let nextOffset = Int(nextOffsetString){
                self?.nextOffset = nextOffset
            }
            onSuccess?()
        }, onError: {
            onError?()
        })
    }

    //pokemon from list tapped
    func didSelectPokemon(pokemon: PokemonCellViewModel){
        if let pokemonModel = self.pokemons.first(where: { $0.id == pokemon.id }){
            coordinator.showPokemonDetails(pokemonModel)
        }else if let pokemonFounded = pokemonFounded, pokemonFounded.id == pokemon.id{
            coordinator.showPokemonDetails(pokemonFounded)
        }
    }
    
    //search pokemon by text, first locally, if no results were founded, call poke api
    func searchPokemon(text: String, onSuccess: (()->Void)?, onError: (()->Void)?){
        self.isSearching = true
        let filteredPokemons = self.searchPokemonsLocally(text: text)
        if filteredPokemons.count > 0 {
            self.pokemonCells = filteredPokemons
            onSuccess?()
        }else{
            var text = text.lowercased()
            if let id = Int(text){  //the text is a number, transform it in int
                text = "\(id)"
            }
            //get the pokemon from server by name or id
            self.coordinator.getPokemon(text, onSuccess: { [weak self] pokemonModel in
                let pokemonCell = PokemonCellViewModel(pokemonModel: pokemonModel)
                self?.pokemonCells = [pokemonCell]
                self?.pokemonFounded = pokemonModel
                DispatchQueue.main.async {
                    onSuccess?()
                }
            }, onError: {
                DispatchQueue.main.async {
                    onError?()
                }
            })
        }
    }
    
    func didFinishSearching(){
        self.isSearching = false
        self.pokemonFounded = nil
        self.pokemonCells.removeAll()
        self.setPokemonCellsWithStoredData()
    }
    
    //MARK: PRIVATE METHODS
    private func setPokemonCellsWithStoredData(){
        self.pokemonCells = self.pokemons.map { pokemon in
            PokemonCellViewModel(pokemonModel: pokemon)
        }
    }
    
    private func searchPokemonsLocally(text: String) -> [PokemonCellViewModel]{
        self.pokemonCells.filter{ pokemonCell in
            //search by id
            if let id = Int(text){
                return pokemonCell.id == id
            }
            //otherwise search by name
            return pokemonCell.name.lowercased().contains(text.lowercased())
        }
    }
}
