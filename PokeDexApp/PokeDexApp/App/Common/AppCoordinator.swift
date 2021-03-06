//
//  Coordinator.swift
//  PokeDexApp
//
//  Created by Andrea Massari on 25/02/21.
//

import UIKit

protocol Coordinator: class{
    var childCoordinators: [Coordinator] { get set}
    var parentCoordinator: Coordinator? { get set }
    func start()
}

extension Coordinator{
    func removeCoordinator(_ childCoordinator: Coordinator){
        childCoordinators = childCoordinators.filter({ $0 !== childCoordinator })
    }
    func addCoordinator(_ childCoordinator: Coordinator){
        childCoordinators.append(childCoordinator)
    }
}

//App coordinator (from AppDelegate)
final class AppCoordinator: Coordinator{
    var parentCoordinator: Coordinator? = nil
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow){
        self.window = window
    }
    
    //Start the app from MainCoordinator and append it in the childCoordinatorsList
    func start() {
        let navigationController = UINavigationController()
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        self.addCoordinator(mainCoordinator)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
