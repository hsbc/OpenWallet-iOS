//
//  AuthServiceTests.swift
//  OpenWalletTests
//
//  Created by WEIHAO ZHANG on 8/10/22.
//

import XCTest
import Alamofire
@testable import OpenWalletOpen

class AuthServiceTests: XCTestCase {
    var authService: AuthService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        let configuration = URLSessionConfiguration.af.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self] + (configuration.protocolClasses ?? [])
        let session = Session(configuration: configuration)

        let mockNetworkManager: NetworkManagerProtocol = NetWorkManager(session: session)
        authService = AuthService(networkManager: mockNetworkManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
        authService = nil
    }

    func test_infoCheckUsername_shouldReturnStatusCode200ForUnusedUsername() async throws {
        URLProtocolStub.loadingHandler = { request in
            debugPrint(request)
            XCTAssertEqual(request.url?.absoluteString, ApiEndPoints.Auth.infoCheckUsername)
            XCTAssertEqual(request.httpMethod, "POST")
            
            let httpUrlResponse = HTTPURLResponse(
                url: URL(string: ApiEndPoints.Auth.infoCheckUsername)!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            let data = Data("{\"message\":\"Username is available.\",\"data\":null}".utf8)
            
            return (httpUrlResponse!, data)
        }
        
        do {
            // When
            let response = try await authService.infoCheckUsername(username: "testUnUsername")

            // Then
            XCTAssertEqual(response.message, "Username is available.")
        } catch {
            XCTFail("Failed test_infoCheckUsername_shouldReturnStatusCode200ForUnusedUsername")
        }
    }

    func test_infoCheckUsername_shouldReturnStatusCode400ForUsedUsername() async throws {
        URLProtocolStub.loadingHandler = { request in
            debugPrint(request)
            XCTAssertEqual(request.url?.absoluteString, ApiEndPoints.Auth.infoCheckUsername)
            XCTAssertEqual(request.httpMethod, "POST")
            
            let httpUrlResponse = HTTPURLResponse(
                url: URL(string: ApiEndPoints.Auth.infoCheckUsername)!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )
            let data = Data("{\"message\":\"Error: Username is already taken!\",\"data\":null}".utf8)
            
            return (httpUrlResponse!, data)
        }
        
        do {
            // When
            _ = try await authService.infoCheckUsername(username: "testUsedUsername")

            // Then
            XCTFail("Failed test_infoCheckUsername_shouldReturnStatusCode400ForUsedUsername")
        } catch let apiError as ApiErrorResponse {
            XCTAssertEqual(apiError.message, "Error: Username is already taken!")
        }
    }

}
