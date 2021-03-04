//
//  StatViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 01/03/21.
//

import UIKit

final class StatViewModel{
    let statName: String
    let statValue: Int
    let progressValue: Float
    let mainColor: UIColor

    init(stats: Stats, mainColor: UIColor){
        self.statValue = stats.baseStat ?? 0
        
        self.statName = stats.stat.name.name
        self.progressValue = Float(self.statValue)/stats.stat.name.maxValue
        
        self.mainColor = mainColor
    }
}
