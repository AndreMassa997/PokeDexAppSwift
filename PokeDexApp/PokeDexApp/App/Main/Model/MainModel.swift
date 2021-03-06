//
//  MainModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

//Pokemons API Model
// MARK: - MainModel
struct MainModel: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [ResultModel]?
}

// MARK: - ResultModel
struct ResultModel: Decodable {
    let name: String?
    let url: URL?
}
