//
//  NetworkServicesTestCase.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 04/09/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class NetworkServicesTestCase: XCTestCase {
    private let queryItems = [
          URLQueryItem(name: "key", value: "123"),
          URLQueryItem(name: "q", value: "La Grande Pyramide de Gizeh")
      ]
      private let urlForTest = URL(string: "https://api.openclassroom.fr")!

    var services: NetworkServices!

    override func setUp() {
        super.setUp()
        services = NetworkServices()
    }
    // MARK: - test createRequest
     func testcreateRequestWhenQueryItemsIsNotNullThenReturnCorrectValue() {

        let result = services.createRequest(url: urlForTest, queryItems: queryItems)

         XCTAssertEqual(result.httpMethod, "GET")
      //  XCTAssertEqual(result.url.?.pathComponents, ["Key","q"])
     }

    func testcheckURLResponse() {

    }
}
