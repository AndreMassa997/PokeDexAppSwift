//
//  MoveViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 02/03/21.
//

import UIKit

final class MovesViewModel{
    let moves: [Move]?
    let mainColor: UIColor
    
    init(moves: [Move]?, mainColor: UIColor){
        self.moves = moves
        self.mainColor = mainColor
    }
}

final class MoveViewModel{
    let moveName: String
    let mainColor: UIColor
    
    init(move: Move, mainColor: UIColor){
        self.moveName = move.move.name
        self.mainColor = mainColor
    }
}
