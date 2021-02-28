//
//  DetailsViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

final class DetailsViewModel{
    let coordinator: DetailsCoordinator
    
    let headerViewModel: DetailsHeaderViewModel
    let mainColor: UIColor
    
    init(with coordinator: DetailsCoordinator, pokemonModel: PokemonModel){
        self.coordinator = coordinator
        self.headerViewModel = DetailsHeaderViewModel(pokemonModel: pokemonModel)
        self.mainColor = pokemonModel.types?.first?.type.name.color() ?? .clear
    }

    public func viewDidDisappear(){
        coordinator.viewDidDisappear()
    }
    
    deinit {
        print("deinitialized DetailsViewModel")
    }
}

