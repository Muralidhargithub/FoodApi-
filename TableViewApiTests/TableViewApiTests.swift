//
//  TableViewApiTests.swift
//  TableViewApiTests
//
//  Created by Muralidhar reddy Kakanuru on 12/10/24.
//

import XCTest
@testable import TableViewApi

final class TableViewApiTests: XCTestCase {

    var viewModel: CustomFoodTableViewModel!
    var networkManagerDebug: NetworkManagerDebug!
    
    override func setUpWithError() throws {
        viewModel = CustomFoodTableViewModel()
        networkManagerDebug = NetworkManagerDebug.shared
    }

    override func tearDownWithError() throws {
        viewModel = nil
        networkManagerDebug = nil
    }
    
    func testNumberOfRowsEmptyData() {
        XCTAssertEqual(viewModel.numberOfRows(), 0, "Number of rows should be 0 when data is empty")
    }

    func testFetchImageWithNilURL() {
        let expectation = XCTestExpectation(description: "Placeholder image should be returned for nil URL")
        viewModel.fetchImage(for: nil) { image in
            XCTAssertEqual(image, UIImage(named: "placeholder"), "Should return placeholder image for nil URL")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDatawithnilFoodData(){
        viewModel.fetchData(with: nil)
        XCTAssertEqual(viewModel.numberOfRows(),0,"nodata should update" )
    }
    
    func testFetchDataWithValidGitData() {
        let expectation = XCTestExpectation(description: "Data fetch should complete")
        viewModel.updateView = {
            expectation.fulfill()
        }

        viewModel.fetchData(with: networkManagerDebug)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.numberOfRows(), 2, "Number of rows should match the number of food groups in mock data")
    }
    
    func testFetchImageWithValidURL() {
        let validImageURL = "https://raw.githubusercontent.com/YevhenBiiak/10-Food/main/Resources/Pizza%20Images/1.png"
        let expectation = XCTestExpectation(description: "Image fetch should return a valid image")

        viewModel.fetchImage(for: validImageURL) { image in
            XCTAssertNotNil(image, "Image should not be nil for a valid URL")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)
    }
    
    func testUpdateViewClosureCalled() {
        
        let expectation = XCTestExpectation(description: "updateView closure should be called after data fetch")

        viewModel.updateView = {
            expectation.fulfill()
        }

        viewModel.fetchData(with: networkManagerDebug)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFoodGroupAtValidIndex() {
        let mockFoodGroups = [
            FoodGroup(
                id: 1,
                name: "Paratha",
                description: "Try pizza cooked in a woodfire oven",
                image_url: "https://raw.githubusercontent.com/YevhenBiiak/10-Food/main/Resources/FoodGroup%20Icons/pizza_icon.png",
                food_items: [
                    FoodItem(
                        id: 11,
                        name: "Margherita",
                        description: "Tomato sauce, Mozarella, Basil",
                        weight: 490,
                        price: 151,
                        image_url: "https://raw.githubusercontent.com/YevhenBiiak/10-Food/main/Resources/Pizza%20Images/1.png"
                    )
                ]
            )
        ]
        viewModel.data = mockFoodGroups

        let foodGroup = viewModel.foodGroup(at: 0)

        XCTAssertEqual(foodGroup.name, "Paratha", "The food group at index 0 should be 'Paratha'")
        XCTAssertEqual(foodGroup.description, "Try pizza cooked in a woodfire oven", "Description should match")
       
    }
    
    
    


}

    
