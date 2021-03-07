//
//  DetailsViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

enum DetailsSectionViewModel{
    case types(items: [CellViewModel])
    case dimensions(items: [CellViewModel])
    case stats(items: [CellViewModel])
    case abilities(items: [CellViewModel])
    
    //get the enum case name and capitalize it
    func getSectionName() -> String?{
        let mirror = Mirror(reflecting: self)
        return mirror.children.first?.label?.capitalized
    }
}

enum CellViewModel{
    case types(items: TypesCellViewModel)
    case stat(statViewModel: StatCellViewModel)
    case dimensions(dimensionsViewModel: DimensionsCellViewModel)
    case ability(abilityViewModel: AbilityCellViewModel)
}

final class DetailsViewModel{
    private let coordinator: DetailsCoordinator
    
    //data for header (carousel images, name, color)
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

        self.setupDataSource(pokemonModel: pokemonModel)
    }
    
    
    //MARK: PRIVATE METHODS
    private func setupDataSource(pokemonModel: PokemonModel){
        //MARK: append datas available from Pokemon model
        let mainColor = pokemonModel.types?.first?.type.name.mainColor ?? .clear
        
        //append types if present
        if let types = pokemonModel.types?.compactMap({ $0.type }){
            self.sectionViewModels.append(.types(items: [
                CellViewModel.types(items: TypesCellViewModel(types: types))
            ]))
        }
        
        //append height and weight
        self.sectionViewModels.append(.dimensions(items: [CellViewModel.dimensions(dimensionsViewModel: DimensionsCellViewModel(height: pokemonModel.height ?? 0, weight: pokemonModel.weight ?? 0, mainColor: mainColor))]))
        
        //append stats into stats section
        self.sectionViewModels.append(.stats(items:
                                                pokemonModel.stats?.compactMap{ stat in
                                                    CellViewModel.stat(statViewModel: StatCellViewModel(stats: stat, mainColor: mainColor))
                                                } ?? []))
        
        //append abilities that are not hidden into abilities section
        self.sectionViewModels.append(.abilities(items: pokemonModel.abilities?.compactMap({ ability in
            CellViewModel.ability(abilityViewModel: AbilityCellViewModel(ability: ability, mainColor: mainColor))
        }) ?? []))
        
    }

    //MARK: PUBLIC METHODS
    func onBackTapped(){
        coordinator.dismissDetails()
    }
    
    func viewDidDisappear(){
        coordinator.viewDidDisappear()
    }
}

//return item from section or nil if no items are in section
extension Array where Element == DetailsSectionViewModel {
    subscript(indexPath: IndexPath) -> CellViewModel? {
        let section = self[indexPath.section]
        switch section {
        case .types(let items), .stats(let items), .dimensions(let items), .abilities(let items):
            return items[indexPath.row]
        }
    }
}

