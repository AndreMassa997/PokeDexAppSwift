//
//  DetailsViewModel.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import Foundation

final class DetailsViewModel{
    let coordinator: DetailsCoordinator
    
    init(with coordinator: DetailsCoordinator){
        self.coordinator = coordinator
    }

    public func viewDidDisappear(){
        coordinator.viewDidDisappear()
    }
    
    deinit {
        print("deinitialized DetailsViewModel")
    }
}

