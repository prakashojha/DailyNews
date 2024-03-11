//
//  TableViewCoordinatorTest.swift
//  DailyNewsTests
//
//  Created by Saumya Prakash on 11/03/24.
//

import XCTest
@testable import DailyNews

struct DummyApiService: APIServiceProtocol {
    func CreateURLRequest(pageLimit: Int) -> URLRequest? {
       return nil
    }
    
    func fetchNews<T>(pageLimit: Int, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        // Do Nothing
    }
    
    func fetchImage(urlString: String, completion: @escaping (Data?) -> Void) {
        // Do Nothing
    }
}


class TableViewCoordinatorTest: XCTestCase {
    
    var viewModel: TableViewModel!
    var model: TableModel!
    var spyCoordinator: SpyTableViewCoordinator!
    
    override func setUpWithError() throws {
        model = TableModel()
        viewModel = TableViewModel(model: model, apiService: DummyApiService())
        spyCoordinator = SpyTableViewCoordinator()
        spyCoordinator.spyLoadWebPageCoordinator = SpyLoadWebPageCoordinator()
        viewModel.coordinator = spyCoordinator
    }
    
    override func tearDownWithError() throws {
        model = nil
        viewModel = nil
        spyCoordinator = nil
    }
    
    func test_whenLoadWebPageExecuted_LoadWebPageMethodInCoordinatorCalled(){
        viewModel.loadWebPage(urlString: "www.google.com")
        XCTAssertEqual(1, spyCoordinator.pageLoadCount)
    }
    
    func test_whenLoadWebPageExecuted_StartFunctionExecutedInLoadWebPageCoordinator(){
        viewModel.loadWebPage(urlString: "www.google.com")
        XCTAssertTrue(spyCoordinator.spyLoadWebPageCoordinator!.isStartCalled)
    }
    
}
