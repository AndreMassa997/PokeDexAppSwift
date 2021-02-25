//
//  MainViewController.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

class MainViewController: UIViewController {
    private var mainViewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        mainViewModel?.getPokemons(offset: 20)
    }
    
    //MARK: PUBLIC METHODS
    public func configure(with viewModel: MainViewModel){
        self.mainViewModel = viewModel
    }
    
    //MARK: PRIVATE METHODS
    
    

}
