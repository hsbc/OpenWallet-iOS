//
//  DateExtensionTests.swift
//  OpenWalletTests
//
//  Created by WEIHAO ZHANG on 8/11/22.
//

import XCTest
@testable import OpenWallet

class DateExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_hourToTimeOfDay_shouldConvertHourToCorrectTimeOfDay() throws {
        XCTAssertEqual(Date.hourToTimeOfDay(0), "Night")
        XCTAssertEqual(Date.hourToTimeOfDay(3), "Night")
        XCTAssertEqual(Date.hourToTimeOfDay(9), "Morning")
        XCTAssertEqual(Date.hourToTimeOfDay(15), "Afternoon")
        XCTAssertEqual(Date.hourToTimeOfDay(18), "Evening")
        XCTAssertEqual(Date.hourToTimeOfDay(21), "Night")
    }
}
