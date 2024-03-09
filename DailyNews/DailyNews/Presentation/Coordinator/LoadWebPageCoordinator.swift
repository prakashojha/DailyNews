//
//  LoadWebPageCoordinator.swift
//  DailyNews
//
//  Created by bindu on 24/10/21.
//

import UIKit
import SafariServices

final class LoadWebPageCoordinator: Coordinator{
    
    
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
        safariViewController.modalPresentationStyle = .fullScreen
        navigationController.present(safariViewController, animated: true, completion: nil)
    }
}
