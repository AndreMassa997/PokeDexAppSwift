//
//  MainCoordinator.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

class MainCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    //MARK: PUBLIC METHODS
    
    //Start the mainViewController and set the mainViewModel
    func start() {
        let mainViewController = MainViewController()
        let mainViewModel = MainViewModel(with: self)
        mainViewController.configure(with: mainViewModel)
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.pushViewController(mainViewController, animated: false)
    }
    
    //pokemon from list tapped
    func showPokemonDetails(_ pokemonModel: PokemonModel){
        let detailsCooordinator = DetailsCoordinator(navigationController: self.navigationController, pokemonModel: pokemonModel)
        self.addCoordinator(detailsCooordinator)
        detailsCooordinator.parentCoordinator = self
        detailsCooordinator.start()
    }
    
    //get list of pokemons from server (paging)
    func getPokemons(offset: Int, onResult: @escaping (MainModel?, [PokemonModel]?, ErrorData?) -> Void){
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: String(offset))
        ]
        PokeAPI.shared.get(path: "pokemon", queryParams: queryItems) { [weak self] data, error in
            guard let data else {
                if let error{
                    onResult(nil, nil, error)
                }else{
                    onResult(nil, nil, .invalidData)
                }
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let mainModel = try jsonDecoder.decode(MainModel.self, from: data)
                let pokemons = SynchronizedArray<PokemonModel>()
                mainModel.results?.forEach{ model in
                    guard let name = model.name else { return }
                    self?.getPokemon(name){ pokemon, error in
                        guard let pokemon else {
                            if let error{
                                onResult(nil, nil, error)
                            }else{
                                onResult(nil, nil, .invalidData)
                            }
                            return
                        }
                        Task{
                            await pokemons.append(pokemon)
                            let allPokemons = await pokemons.array
                            DispatchQueue.main.async {
                                if allPokemons.count == mainModel.results?.count{
                                    onResult(mainModel, allPokemons, nil)
                                }
                            }
                        }
                    }
                }
            }catch{
                DispatchQueue.main.async {
                    onResult(nil, nil, .invalidData)
                }
            }
        }
    }
        
    //get pokemon with name or id
    func getPokemon(_ nameOrId: String, onResult: @escaping (PokemonModel?, ErrorData?) -> Void){
        PokeAPI.shared.get(path: "pokemon/\(nameOrId)"){ data, error in
            guard let data else {
                if let error{
                    onResult(nil, error)
                }else{
                    onResult(nil, .invalidData)
                }
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemonModel = try jsonDecoder.decode(PokemonModel.self, from: data)
                onResult(pokemonModel, nil)
            }
            catch{
                onResult(nil, .invalidData)
            }
        }
    }
}

/// A thread-safe array.
private actor SynchronizedArray<Element> {
    fileprivate var array = [Element]()
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameter element: The element to append to the array.
    func append( _ element: Element) {
        self.array.append(element)
    }
}
