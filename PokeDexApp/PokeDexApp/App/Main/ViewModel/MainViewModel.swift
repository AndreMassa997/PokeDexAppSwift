//
//  MainViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

final class MainViewModel{
    var coordinator: MainCoordinator?
    
    init(with coordinator: MainCoordinator){
        self.coordinator = coordinator
    }
    
    public func showDetail(){
        coordinator?.showDetail()
    }
}
