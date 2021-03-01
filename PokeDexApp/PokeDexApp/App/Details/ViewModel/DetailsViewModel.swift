//
//  DetailsViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

enum DetailsSectionViewModel{
    case stats(items: [CellViewModel])
    case evolutions(items: [CellViewModel])
}

enum CellViewModel{
    case stat(stat: StatViewModel)
    case evolution(evolution: String)
}

final class DetailsViewModel{
    let coordinator: DetailsCoordinator
    
    let headerViewModel: DetailsHeaderViewModel
    private(set) var sectionViewModels: [DetailsSectionViewModel] = []
    let mainColor: UIColor
    let endColor: UIColor
    
    init(with coordinator: DetailsCoordinator, pokemonModel: PokemonModel){
        self.coordinator = coordinator
        self.headerViewModel = DetailsHeaderViewModel(pokemonModel: pokemonModel)
        self.mainColor = pokemonModel.types?.first?.type.name.mainColor ?? .clear
        self.endColor = pokemonModel.types?.first?.type.name.endColor ?? .clear
        
        //append stats into stats section
        self.sectionViewModels.append(.stats(items:
                                                pokemonModel.stats?.compactMap{ stat in
                                                    CellViewModel.stat(stat: StatViewModel(stats: stat, mainColor: pokemonModel.types?.first?.type.name.mainColor ?? .clear, endColor: pokemonModel.types?.first?.type.name.endColor ?? .clear))
                                                } ?? []))
        
        //append evolutions into evolution section
        
        
    }

    public func viewDidDisappear(){
        coordinator.viewDidDisappear()
    }
    
    deinit {
        print("deinitialized DetailsViewModel")
    }
}

extension Array where Element == DetailsSectionViewModel {
    subscript(indexPath: IndexPath) -> CellViewModel {
        let section = self[indexPath.section]
        switch section {
        case .stats(let items), .evolutions(let items):
            return items[indexPath.row]
        }
    }
}

