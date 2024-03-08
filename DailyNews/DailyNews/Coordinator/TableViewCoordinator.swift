//
//  TableViewCoordinator.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit

protocol TableViewCoordinatorDelegate {
    func loadWebPage(url: URL)
    func showAlert(_ withReason: String)
}
    

final class TableViewCoordinator: Coordinator{
    private (set) var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let apiService: APIServiceProtocol = APIService()
        let viewController = ViewController()
        let tableModel = DNTableModel()
        let dnTableViewViewModel = DNTableViewModel(model: tableModel, apiService: apiService)
        viewController.tableViewModel = dnTableViewViewModel
        dnTableViewViewModel.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension TableViewCoordinator: TableViewCoordinatorDelegate {
    
    func loadWebPage(url: URL){
        let loadWebPageCoordinator = LoadWebPageCoordinator(navigationController: navigationController, url: url)
        childCoordinators.append(loadWebPageCoordinator)
        loadWebPageCoordinator.start()
    }
    
    func showAlert(_ withReason: String){
        let alertController = UIAlertController(title: "DN News", message: withReason , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.viewControllers.first?.present(alertController, animated: true)
    }
}
