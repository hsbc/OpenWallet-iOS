//
//  URLProtocolStub.swift
//  OpenWalletTests
//
//  Created by WEIHAO ZHANG on 8/16/22.
//

import Foundation
import XCTest

final class URLProtocolStub: URLProtocol {
  
  static var loadingHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
    
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
    
  override func startLoading() {
    guard let handler = Self.loadingHandler else {
      XCTFail("Loading handler is not set.")
      return
    }
    do {
      let (response, data) = try handler(request)
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
    
  override func stopLoading() { }

}
