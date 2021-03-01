//
//  DetailCoordinator.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

final class DetailsCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    private let navigationController: UINavigationController
    private let pokemonModel: PokemonModel
    
    init(navigationController: UINavigationController, pokemonModel: PokemonModel){
        self.navigationController = navigationController
        self.pokemonModel = pokemonModel
    }
    
    //MARK: PUBLIC METHODS
    
    //Start the detail page
    func start() {
        let detailsViewController = DetailsViewController()
        let detailsViewModel = DetailsViewModel(with: self, pokemonModel: pokemonModel)
        detailsViewController.modalPresentationStyle = .fullScreen
        detailsViewController.configureDetailView(with: detailsViewModel)
        navigationController.present(detailsViewController, animated: true)
    }
    
    //Call on viewDidDisappear to deallocate coordinator instance
    func dismissDetails(){
        navigationController.popViewController(animated: true)
        parentCoordinator?.removeCoordinator(self)
    }
    
    func getPokemonSpecies(pokemonId: Int, onSuccess:((_ pokemonSpecies: PokemonSpecies) -> Void)?){
        PokeAPI.shared.get(path: "pokemon-species/\(pokemonId)", onSuccess: { data in
            do{
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            let pokemonSpecies = try jsonDecoder.decode(PokemonSpecies.self, from: data)
            onSuccess?(pokemonSpecies)
            }
            catch let error{
                print(error)
            }
        }, onErrorHandled: {
            
        })
    }
    
    func getEvolutionChain(idEvolutionChain: String, onSuccess:((_ evolutionChain: EvolutionModel) -> Void)?){
        PokeAPI.shared.get(path: "evolution-chain/\(idEvolutionChain)", onSuccess: { data in
            do{
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let evolutionModel = try jsonDecoder.decode(EvolutionModel.self, from: data)
                onSuccess?(evolutionModel)
            }
            catch let error{
                print(error)
            }
        }, onErrorHandled: {
            
        })
    }
    
    
    deinit {
        print("deinitilized DetailsCoordinator")
    }
    
    
    
    
}
