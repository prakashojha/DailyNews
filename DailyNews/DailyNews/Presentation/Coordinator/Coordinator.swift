//
//  Coordinator.swift
//  DailyNews
//
//  Created by Saumya Prakash on 11/03/24.
//

import Foundation


protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get}
    func add(coordinator: Coordinator)
    func remove(coordinator: Coordinator)
    func start()
}
