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
   
    var parentCoordinator: Coordinator?
    private (set) var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let apiClient: URLRequestProtocol = Environment.shared.apiClient
        let apiService: APIServiceProtocol = APIService(urlRequest: apiClient)
        let tableModel: TableModel = TableModel()
        let dnTableViewViewModel: TableViewModel = TableViewModel(model: tableModel, apiService: apiService)
        dnTableViewViewModel.coordinator = self

        let viewController = ViewController(tableViewModel: dnTableViewViewModel)
        navigationController.setViewControllers([viewController], animated: false)
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

extension TableViewCoordinator: TableViewCoordinatorDelegate {
    
    func loadWebPage(url: URL){
        let loadWebPageCoordinator: LoadWebPageCoordinator = LoadWebPageCoordinator(navigationController: navigationController, url: url)
        loadWebPageCoordinator.parentCoordinator = self
        childCoordinators.append(loadWebPageCoordinator)
        print(childCoordinators.count)
        loadWebPageCoordinator.start()
    }
    
    func showAlert(_ withReason: String){
        let alertController = UIAlertController(title: "Daily News", message: withReason , preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        navigationController.viewControllers.first?.present(alertController, animated: true)
    }
    
}
