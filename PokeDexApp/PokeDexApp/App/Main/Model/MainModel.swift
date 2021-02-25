//
//  MainModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

// MARK: - MainModel
struct MainModel: Decodable {
    let count: Int
    let next: URL?
    let previous: URL?
    let results: [ResultModel]?
    
    enum CodingKeys: String, CodingKey{
        case count, next, previous, results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.next = URL(string: try container.decode(String.self, forKey: .next))
        self.previous = URL(string: try container.decode(String.self, forKey: .previous))
        self.results = try container.decode([ResultModel].self, forKey: .results)
    }
}

// MARK: - ResultModel
struct ResultModel: Decodable {
    let name: String?
    let url: URL?
    
    enum CodingKeys: String, CodingKey{
        case name, url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = URL(string: try container.decode(String.self, forKey: .url))
    }
}
