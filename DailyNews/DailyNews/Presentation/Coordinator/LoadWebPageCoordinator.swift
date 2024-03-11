//
//  LoadWebPageCoordinator.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit
import SafariServices

final class LoadWebPageCoordinator: NSObject, Coordinator{
 
    var parentCoordinator: Coordinator?
    private (set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private let url: URL
    
    
    init(navigationController: UINavigationController, url: URL){
        self.navigationController = navigationController
        self.url = url
    }
    
    func start() {
        let config = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: config)
        safariViewController.delegate = self
        safariViewController.modalPresentationStyle = .fullScreen
        navigationController.present(safariViewController, animated: true, completion: nil)
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

extension LoadWebPageCoordinator: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.parentCoordinator?.remove(coordinator: self)
    }
}
