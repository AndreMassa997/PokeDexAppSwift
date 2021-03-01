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
    let statsViewModels: [StatsViewModel]
    let mainColor: UIColor
    let endColor: UIColor
    
    init(with coordinator: DetailsCoordinator, pokemonModel: PokemonModel){
        self.coordinator = coordinator
        self.headerViewModel = DetailsHeaderViewModel(pokemonModel: pokemonModel)
        self.mainColor = pokemonModel.types?.first?.type.name.mainColor ?? .clear
        self.endColor = pokemonModel.types?.first?.type.name.endColor ?? .clear
        self.statsViewModels = pokemonModel.stats?.compactMap{ stat in
            StatsViewModel(stats: stat, mainColor: pokemonModel.types?.first?.type.name.mainColor ?? .clear, endColor: pokemonModel.types?.first?.type.name.endColor ?? .clear)
        } ?? []
    }

    public func viewDidDisappear(){
        coordinator.viewDidDisappear()
    }
    
    deinit {
        print("deinitialized DetailsViewModel")
    }
}

