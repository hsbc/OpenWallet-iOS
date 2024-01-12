//
//  StringExtensionTests.swift
//  OpenWalletTests
//
//  Created by WEIHAO ZHANG on 8/11/22.
//

import XCTest
@testable import OpenWallet

class StringExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_isEmail_shouldCheckIfAStringIsAnEmailAddressOrNot() throws {
        let testNonEmail: String = "test@"
        let testEmail: String = "test@admin.com"
        
        XCTAssertFalse(testNonEmail.isEmail)
        XCTAssertTrue(testEmail.isEmail)
    }
    
    func test_isAcceptablePassword_shouldCheckIfAStringIsAValidPasswordOrNot() throws {
        let testBadPasswordNotEnoughLength: String = "123456"
        let testBadPasswordOnlyLetter: String = "abcdedfg"
        let testBadPasswordOnlyNumberAndLowerCaseLetter: String = "1234abcde"
        let testBadPasswordOnlyNumberAndUpperCaseLetter: String = "1234ABCDE"
        let testBadPasswordOnlySpecialCharaters: String = "!@#$%^&*"

        let testGoodPasswordNumberAndLowerCaseAndUpperCaseLetter: String = "1234abcDE"
        let testGoodPasswordNumberAndLowerCaseLetterAndSpecialCharacter: String = "1234abc!@#"
        let testGoodPasswordNumberAndUpperCaseLetterAndSpecialCharacter: String = "123ABC!@#"
        let testGoodPasswordLowerUpperCaseLetterSpecialCharacter: String = "1234abCD!@#"
        let testGoodPasswordNumberLowerUpperCaseLetterSpecialCharacter: String = "1234abcDE!@"
        
        XCTAssertFalse(testBadPasswordNotEnoughLength.isAcceptablePassword)
        XCTAssertFalse(testBadPasswordOnlyLetter.isAcceptablePassword)
        XCTAssertFalse(testBadPasswordOnlyNumberAndLowerCaseLetter.isAcceptablePassword)
        XCTAssertFalse(testBadPasswordOnlyNumberAndUpperCaseLetter.isAcceptablePassword)
        XCTAssertFalse(testBadPasswordOnlySpecialCharaters.isAcceptablePassword)
        
        XCTAssertTrue(testGoodPasswordNumberAndLowerCaseAndUpperCaseLetter.isAcceptablePassword)
        XCTAssertTrue(testGoodPasswordNumberAndLowerCaseLetterAndSpecialCharacter.isAcceptablePassword)
        XCTAssertTrue(testGoodPasswordNumberAndUpperCaseLetterAndSpecialCharacter.isAcceptablePassword)
        XCTAssertTrue(testGoodPasswordLowerUpperCaseLetterSpecialCharacter.isAcceptablePassword)
        XCTAssertTrue(testGoodPasswordNumberLowerUpperCaseLetterSpecialCharacter.isAcceptablePassword)
    }

}
