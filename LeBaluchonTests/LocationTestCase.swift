//
//  LocationTestCase.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 10/09/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import XCTest

@testable import LeBaluchon

class LocationTestCase: XCTestCase {

    func testGivenFirstLocationWhenCompareAnOtherLocationThenReturnFalse() {

        let firstLocation: Location
        let secondLocation: Location

        // Given
        firstLocation = .town("New York", "fr")

        // When
        secondLocation = .town("Annecy", "fr")

        // Then
        XCTAssertNotEqual(firstLocation, secondLocation)
    }
}
