//
//  MainCoordinator.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

final class MainCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    private let navigationController: UINavigationController
    private var pokemons: [PokemonModel] = []
    
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
    func showPokemonDetails(pokemon: PokemonCellModel){
        guard let pokemonModel = self.pokemons.first(where: { $0.id == pokemon.id }) else {
            //TODO: SHOW ERROR POPUP
            return
        }
        let detailsCooordinator = DetailsCoordinator(navigationController: self.navigationController, pokemonModel: pokemonModel)
        self.addCoordinator(detailsCooordinator)
        detailsCooordinator.parentCoordinator = self
        detailsCooordinator.start()
    }
    
    func getPokemons(offset: Int, onSuccess:((_ mainModel: MainModel, _ pokemons: [PokemonCellModel]) -> Void)?){
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: String(offset))
        ]
        PokeAPI.shared.get(path: "pokemon", queryParams: queryItems,
                           onSuccess: { data in
                            do {
                                let jsonDecoder = JSONDecoder()
                                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                                let mainModel = try jsonDecoder.decode(MainModel.self, from: data)
                                let group = DispatchGroup()
                                var pokemons: [PokemonCellModel] = []
                                mainModel.results?.forEach{ result in
                                    guard let name = result.name else { return }
                                    group.enter()
                                    PokeAPI.shared.get(path: "pokemon/\(name)", onSuccess: { [weak self] data in
                                        do {
                                            let jsonDecoder = JSONDecoder()
                                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                                            let pokemonModel = try jsonDecoder.decode(PokemonModel.self, from: data)
                                            self?.pokemons.append(pokemonModel)
                                            pokemons.append(PokemonCellModel(pokemonModel: pokemonModel))
                                            group.leave()
                                        }
                                        catch let error{
                                            print(error)
                                        }
                                    }, onErrorHandled: {
                                        group.leave()
                                    })
                                }
                                group.notify(queue: .main) { [weak self] in
                                    self?.pokemons.sort(by: { $0.id < $1.id })
                                    pokemons.sort(by: { $0.id < $1.id })
                                    onSuccess?(mainModel, pokemons)
                                }
                            }
                            catch{
                                
                            }
                            }, onErrorHandled: {
                            
                            })
    }
    
    
    
    
    
    
}
