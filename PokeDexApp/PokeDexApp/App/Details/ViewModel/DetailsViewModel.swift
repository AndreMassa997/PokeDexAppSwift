//
//  DetailsViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

enum DetailsSectionViewModel{
    case abilities(items: [CellViewModel])
    case dimensions(items: [CellViewModel])
    case stats(items: [CellViewModel])
    case moves(items: [CellViewModel])
    
    //get the enum case name and capitalize it
    func getSectionName() -> String?{
        let mirror = Mirror(reflecting: self)
        return mirror.children.first?.label?.capitalized
    }
}

enum CellViewModel{
    case ability(abilityViewModel: AbilityViewModel)
    case stat(statViewModel: StatViewModel)
    case dimensions(dimensionsViewModel: DimensionsViewModel)
    case moves(movesViewModel: MovesViewModel)
}

final class DetailsViewModel{
    let coordinator: DetailsCoordinator
    
    //data for header (carousel images, name, color and types)
    let headerViewModel: DetailsHeaderViewModel
    
    //data for tableView (sections with description, stats)
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
        
        let mainColor = pokemonModel.types?.first?.type.name.mainColor ?? .clear
        
        //MARK: append data available from Pokemon model
        
        //append abilities that are not hidden into abilities section
        self.sectionViewModels.append(.abilities(items: pokemonModel.abilities?.compactMap({ ability in
            CellViewModel.ability(abilityViewModel: AbilityViewModel(ability: ability, mainColor: mainColor))
        }) ?? []))
        
        //append height and weight
        self.sectionViewModels.append(.dimensions(items: [CellViewModel.dimensions(dimensionsViewModel: DimensionsViewModel(height: pokemonModel.height ?? 0, weight: pokemonModel.weight ?? 0, mainColor: mainColor))]))
        
        //append stats into stats section
        self.sectionViewModels.append(.stats(items:
                                                pokemonModel.stats?.compactMap{ stat in
                                                    CellViewModel.stat(statViewModel: StatViewModel(stats: stat, mainColor: mainColor, endColor: pokemonModel.types?.first?.type.name.endColor ?? .clear))
                                                } ?? []))
        
        //append moves into stats section
        self.sectionViewModels.append(.moves(
                                        items: [CellViewModel.moves(movesViewModel: MovesViewModel(moves: pokemonModel.moves, mainColor: mainColor))]))
        
    }

    //MARK: PUBLIC METHODS
    func onDismissTapped(){
        coordinator.dismissDetails()
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
        case .stats(let items), .dimensions(let items), .abilities(let items), .moves(let items):
            return items[indexPath.row]
        }
    }
}

