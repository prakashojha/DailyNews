//
//  TableViewCoordinator.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

final class TableViewCoordinator: Coordinator{
    private (set) var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewController()
        let tableModel = DNTableModel()
        let dnTableViewViewModel = DNTableViewModel(model: tableModel)
        viewController.tableViewModel = dnTableViewViewModel
        navigationController.setViewControllers([viewController], animated: false)
    }
}
