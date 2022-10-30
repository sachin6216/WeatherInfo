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

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        /// Test case for check API is working or not
        let expectation = XCTestExpectation(description: "response")

        HomeEndPoint.getCurrentWeather(query: "Chandigarh").instance.executeQuery { (response: GetWeather) in
            XCTAssertEqual(response.location?.region ?? "", "Chandigarh")
            expectation.fulfill()
        } error: { (errorMsg) in
            XCTAssertFalse(errorMsg != "")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
