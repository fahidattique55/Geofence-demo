//
//  TestGeofenceTests.swift
//  TestGeofenceTests
//
//  Created by Fahad Attique on 01/08/2019.
//  Copyright © 2019 UMAI. All rights reserved.
//

import XCTest
@testable import TestGeofence

class TestGeofenceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //  Not working on simulator -- I suspect that I need to connect a device but doesn't have apple id info to configure wifi in capabilities.
        
        let wifis = appUtility.getConnectedWifiInfo()
        print(wifis)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
