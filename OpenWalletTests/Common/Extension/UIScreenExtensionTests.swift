//
//  UIScreenExtensionTests.swift
//  OpenWalletTests
//
//  Created by WEIHAO ZHANG on 8/11/22.
//

import XCTest
@testable import OpenWallet

class UIScreenExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_screenWidth_shouldReturnWidthOfTheUIScreenMainBounds() throws {
        XCTAssertEqual(UIScreen.screenWidth, UIScreen.main.bounds.width)
    }

    func test_screenHeight_shouldReturnHeightOfTheUIScreenMainBounds() throws {
        XCTAssertEqual(UIScreen.screenHeight, UIScreen.main.bounds.height)
    }

    func test_screenSize_shouldReturnSizeOfTheUIScreenMainBounds() throws {
        XCTAssertEqual(UIScreen.screenSize, UIScreen.main.bounds.size)
    }
}
