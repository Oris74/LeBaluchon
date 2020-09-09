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

    // MARK: - test getValueForAPIKey
    func testGivenAPINameWhenNameIsNotNullThenReturnKey() {
        let result = Utilities.getValueForAPIKey(named: "API_Fixer")
        // Then
        XCTAssertNotNil(result)
    }
    func testGivenAPINameWhenNameIsNotKnownThenReturnNil() {
          let result = Utilities.getValueForAPIKey(named: "OpenClassRoom")
          // Then
          XCTAssertNil(result)
      }
}
