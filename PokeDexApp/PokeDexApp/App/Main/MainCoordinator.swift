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
    func getPokemons(offset: Int, onSuccess:((_ mainModel: MainModel, _ pokemons: [PokemonModel]) -> Void)?, onError:(() -> Void)?){
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: String(offset))
        ]
        PokeAPI.shared.get(path: "pokemon", queryParams: queryItems,
                           onSuccess: { [weak self] data in
                            do {
                                let jsonDecoder = JSONDecoder()
                                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                                let mainModel = try jsonDecoder.decode(MainModel.self, from: data)
                                let group = DispatchGroup()
                                var pokemons: [PokemonModel] = []
                                
                                mainModel.results?.forEach{ result in
                                    guard let name = result.name else { return }
                                    
                                    group.enter()
                                    self?.getPokemon(name, onSuccess: { pokemonModel in
                                        pokemons.append(pokemonModel)
                                        group.leave()
                                    }, onError: {
                                        group.leave()
                                    })
                                    
                                }
                                group.notify(queue: .main) {
                                    onSuccess?(mainModel, pokemons)
                                }
                            }
                            catch{
                                DispatchQueue.main.async {
                                    onError?()
                                }
                            }
                           }, onError: {
                            DispatchQueue.main.async {
                                onError?()
                            }
                           })
    }
        
    //get pokemon with name or id
    func getPokemon(_ nameOrId: String, onSuccess: ((_ pokemons: PokemonModel) -> Void)?, onError: (()-> Void)?){
        PokeAPI.shared.get(path: "pokemon/\(nameOrId)", onSuccess: { data in
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let pokemonModel = try jsonDecoder.decode(PokemonModel.self, from: data)
                onSuccess?(pokemonModel)
            }
            catch{
                onError?()
            }
        }, onError: {
            onError?()
        })
    }
}
