//
//  DetailsViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

enum DetailsSectionViewModel{
    case descriptions(items: [CellViewModel]?)
    case stats(items: [CellViewModel])
    case evolutions(items: [CellViewModel]?)
}

enum CellViewModel{
    case description(description: String)
    case stat(stat: StatViewModel)
    case evolution(evolution: String)
}

final class DetailsViewModel{
    let coordinator: DetailsCoordinator
    
    //data for header (carousel images, name, color and types)
    let headerViewModel: DetailsHeaderViewModel
    
    //data for tableView (sections with description, stats and evolutions)
    private(set) var sectionViewModels: [DetailsSectionViewModel] = []
    
    //colors for background gradient
    let mainColor: UIColor
    let endColor: UIColor
    let id: Int
    
    init(with coordinator: DetailsCoordinator, pokemonModel: PokemonModel){
        self.coordinator = coordinator
        self.headerViewModel = DetailsHeaderViewModel(pokemonModel: pokemonModel)
        self.mainColor = pokemonModel.types?.first?.type.name.mainColor ?? .clear
        self.endColor = pokemonModel.types?.first?.type.name.endColor ?? .clear
        self.id = pokemonModel.id
        
        //append nil description
        self.sectionViewModels.append(.descriptions(items: nil))
        
        //append stats into stats section
        self.sectionViewModels.append(.stats(items:
                                                pokemonModel.stats?.compactMap{ stat in
                                                    CellViewModel.stat(stat: StatViewModel(stats: stat, mainColor: pokemonModel.types?.first?.type.name.mainColor ?? .clear, endColor: pokemonModel.types?.first?.type.name.endColor ?? .clear))
                                                } ?? []))
        
        //append evolutions into evolution section
        self.sectionViewModels.append(.evolutions(items: nil))
    }

    //MARK: PUBLIC METHODS
    func onDismissTapped(){
        coordinator.dismissDetails()
    }
    
    func getPokemonSpeciesAndEvolutionChain(onSuccess: (() -> Void
    )?){
        self.coordinator.getPokemonSpecies(pokemonId: self.id, onSuccess: { [weak self] pokemonSpecies in
            self?.sectionViewModels.remove(at: 0)
            self?.sectionViewModels.insert(.descriptions(items: [.description(description: pokemonSpecies.flavorTextEntries.first?.flavorText ?? "")]), at: 0)
            let idEvolutionChain = pokemonSpecies.evolutionChain.url.lastPathComponent
            self?.coordinator.getEvolutionChain(idEvolutionChain: idEvolutionChain, onSuccess: { evolutionModel in
                
            })
            onSuccess?()
        })
    }
    
    
    
    deinit {
        print("deinitialized DetailsViewModel")
    }
}

//return item from section or nil if no items are in section
extension Array where Element == DetailsSectionViewModel {
    subscript(indexPath: IndexPath) -> CellViewModel? {
        let section = self[indexPath.section]
        switch section {
        case .stats(let items):
            return items[indexPath.row]
        case .descriptions(let items), .evolutions(let items):
            return items?[indexPath.row]
        }
    }
}

