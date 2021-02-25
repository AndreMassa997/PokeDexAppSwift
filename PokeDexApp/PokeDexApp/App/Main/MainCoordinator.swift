//
//  MainCoordinator.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

final class MainCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var parentCoordinator: Coordinator?
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    //Start the mainViewController and set the mainViewModel
    func start() {
        let mainViewController = MainViewController()
        let mainViewModel = MainViewModel(with: self)
        mainViewController.configure(with: mainViewModel)
        self.navigationController.pushViewController(mainViewController, animated: false)
    }
    
    func showDetail(){
        let detailsCooordinator = DetailsCoordinator(navigationController: self.navigationController)
        self.addCoordinator(detailsCooordinator)
        detailsCooordinator.parentCoordinator = self
        detailsCooordinator.start()
    }
    
    
    
}
