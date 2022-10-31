//
//  Weather_InfoTests.swift
//  Weather InfoTests
//
//  Created by Sachin on 30/10/22.
//

import XCTest
@testable import Weather_Info
final class Weather_InfoTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRegionShouldBeMatched() throws {
        /// Test case for check API is working or not
        let expectation = XCTestExpectation(description: "response")
        
        HomeEndPoint.getCurrentWeather(query: "Chandigarh").instance.executeQuery { (response: GetWeather) in
            /// Check Postive cases
            // If query and region value is same then test cases pass
            XCTAssertEqual(response.location?.region ?? "", "Chandigarh")
            expectation.fulfill()
        } error: { (errorMsg) in
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    
    func testWeatherMeasurementPostiveValues() throws {
        /// Test case for check API is working or not
        let expectation = XCTestExpectation(description: "response")
        
        HomeEndPoint.getCurrentWeather(query: "Chandigarh").instance.executeQuery { (response: GetWeather) in
            /// Check Postive cases
            
            // Check test cases for only postive values
            XCTAssertFalse((response.current?.windSpeed ?? 0.0) <= 0.0)
            XCTAssertFalse((response.current?.pressure ?? 0.0) <= 0.0)
            expectation.fulfill()
        } error: { (errorMsg) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
    func testQueryShouldBeNotNull() throws {
        /// Test case for check API is working or not
        let expectation = XCTestExpectation(description: "response")
        
        HomeEndPoint.getCurrentWeather(query: "").instance.executeQuery { (response: GetWeather) in
            expectation.fulfill()
        } error: { (errorMsg) in
            /// Check Postive cases
            XCTAssertFalse(errorMsg != "")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
