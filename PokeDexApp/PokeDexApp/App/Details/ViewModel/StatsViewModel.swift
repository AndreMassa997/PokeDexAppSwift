//
//  StatsViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 01/03/21.
//

import UIKit

final class StatsViewModel{
    
    let statName: String
    let statValue: Int
    let progressValue: Float
    let mainColor: UIColor
    let endColor: UIColor

    init(stats: Stats, mainColor: UIColor, endColor: UIColor){
        self.statValue = stats.baseStat ?? 0
        
        self.statName = stats.stat.name.name
        self.progressValue = Float(self.statValue)/stats.stat.name.maxValue
        
        self.mainColor = mainColor
        self.endColor = endColor
    }
}
