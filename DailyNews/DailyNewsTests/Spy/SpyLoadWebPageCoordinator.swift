//
//  SpyLoadWebPageCoordinator.swift
//  DailyNewsTests
//
//  Created by Saumya Prakash on 11/03/24.
//

import XCTest
@testable import DailyNews

class SpyLoadWebPageCoordinator: Coordinator {
    var parentCoordinator: DailyNews.Coordinator?
    
    func add(coordinator: DailyNews.Coordinator) {
        //
    }
    
    func remove(coordinator: DailyNews.Coordinator) {
        //
    }
    
    
    var childCoordinators: [Coordinator] = []
    var isStartCalled: Bool = false
    
    
    func start() {
        isStartCalled = true
    }
    
}
