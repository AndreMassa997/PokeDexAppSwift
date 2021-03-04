//
//  WidthHeightViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 03/03/21.
//

import UIKit

final class DimensionsViewModel{
    let weight: Float
    let height: Float
    let mainColor: UIColor
    let heightProgressValue: Float
    let weightProgressValue: Float
    
    //height and weight from pokemonmodel arrive in decimeters and hectograms, convert into meters and kilograms
    init(height: Int, weight: Int, mainColor: UIColor) {
        self.weight = Float(weight)/10
        self.height = Float(height)/10
        self.mainColor = mainColor
        
       //get the maximum values of height (20m) and weight (1000kg) in https://pokemondb.net/pokedex/stats/height-weight
        self.heightProgressValue = self.height/20
        self.weightProgressValue = self.weight/1000
    }
    
}
