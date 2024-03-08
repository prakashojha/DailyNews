//
//  SpyCoordinator.swift
//  DailyNewsTests
//
//  Created by Saumya Prakash on 8/03/24.
//

import XCTest
@testable import DailyNews

class SpyCoordinator: TableViewCoordinatorDelegate {
   
    var pageLoadCount: Int
    var alertCount: Int = 0
    
    init(){
        pageLoadCount = 0
    }
    
    func start() {
        //
    }
    
    func loadWebPage(url: URL) {
        self.pageLoadCount += 1
    }
    
    func showAlert(_ withReason: String){
        self.alertCount += 1
    }
    
}
