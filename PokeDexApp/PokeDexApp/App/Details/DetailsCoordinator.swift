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
    
    deinit {
        print("deinitilized DetailsCoordinator")
    }
    
    
    
    
}
