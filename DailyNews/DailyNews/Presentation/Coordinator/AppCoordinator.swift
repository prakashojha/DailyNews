//
//  AppCoordinator.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit


final class AppCoordinator: Coordinator{
   
    var parentCoordinator: Coordinator? = nil
    
    private (set) var childCoordinators: [Coordinator] = []
    let window: UIWindow
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        let navigationController: UINavigationController = UINavigationController()
        let tableViewCoordinator: TableViewCoordinator = TableViewCoordinator(navigationController: navigationController)
        tableViewCoordinator.parentCoordinator = self
        self.add(coordinator: tableViewCoordinator)
        tableViewCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func add(coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }
    
    func remove(coordinator: Coordinator) {
        for(index, childCoordinator) in self.childCoordinators.enumerated() {
            if childCoordinator === coordinator {
                self.childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
