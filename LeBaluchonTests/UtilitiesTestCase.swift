//
//  UtilitiesTestCase.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 01/09/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation
import XCTest
@testable import LeBaluchon

class UtilitiesTestCase: XCTestCase {
    private var queryItems: [String: String?] =
        ["key": "123",
         "q": "La Grande Pyramide de Gizeh"]
    private let urlForTest = URL(string: "https://api.openclassroom.fr")!

    // MARK: - test createRequest
    func testcreateRequestWhenQueryItemsIsNotNullThenReturnCorrectValue() {

        let result = Utilities.createRequest(url: urlForTest, queryItems: queryItems)

        XCTAssertEqual(result.httpMethod, "GET")
        XCTAssertEqual(result.url?.absoluteURL,
        "https://api.openclassroom.fr?&q=La%20Grande%20Pyramide%20de%20Gizeh&key=123")
    }

    // MARK: - test getValueForAPIKey
    func testGivenAPINameWhenNameIsNotNullThenReturnKey() {
        let result = Utilities.getValueForAPIKey(named: "API_Fixer")
        // Then
        XCTAssertNotNil(result)
    }
}
