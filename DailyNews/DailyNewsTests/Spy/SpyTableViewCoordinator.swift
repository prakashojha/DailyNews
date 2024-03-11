//
//  SpyTableViewCoordinator.swift
//  DailyNewsTests
//
//  Created by Saumya Prakash on 8/03/24.
//

import XCTest
@testable import DailyNews

class SpyTableViewCoordinator: Coordinator, TableViewCoordinatorDelegate {
    var parentCoordinator: DailyNews.Coordinator?
    
   
    var childCoordinators: [DailyNews.Coordinator] = []
    var pageLoadCount: Int
    var alertCount: Int = 0
    var spyLoadWebPageCoordinator: SpyLoadWebPageCoordinator? = nil
    
    init(){
        pageLoadCount = 0
    }
    
    func start() {
        
    }
    
    func add(coordinator: DailyNews.Coordinator) {
        //
    }
    
    func remove(coordinator: DailyNews.Coordinator) {
        //
    }
    
    
    func loadWebPage(url: URL) {
        self.pageLoadCount += 1
        self.spyLoadWebPageCoordinator?.start()
    }
    
    func showAlert(_ withReason: String){
        self.alertCount += 1
    }
    
}
