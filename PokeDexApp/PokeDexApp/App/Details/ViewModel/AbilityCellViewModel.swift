//
//  AbilityViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 02/03/21.
//

import UIKit

struct AbilityCellViewModel{
    let abilityName: String
    let mainColor: UIColor
    
    init(ability: Ability, mainColor: UIColor){
        self.abilityName = ability.ability.name
        self.mainColor = mainColor
    }
}
