//
//  AppCoordinator.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

protocol Coordinator{
    var childCoordinators: [Coordinator] {get}
    func start()
}

final class AppCoordinator: Coordinator{
    private (set) var childCoordinators: [Coordinator] = []
    let window: UIWindow
    
    init(window: UIWindow){
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        let tableViewCoordinator = TableViewCoordinator(navigationController: navigationController)
        childCoordinators.append(tableViewCoordinator)
        tableViewCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
