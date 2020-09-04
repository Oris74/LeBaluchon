//
//  ExchangeRatesServiceTests.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import XCTest

@testable import LeBaluchon

class ExchangeRatesServiceTestCase: XCTestCase {
    var exchangeRatesService: ExchangeRatesService!

       override func setUp() {
           super.setUp()
           exchangeRatesService = ExchangeRatesService()
       }
    func testGetExchangeRatesShouldPostFailedCallback() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            exchangeRateSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (errorCode, exchangeRates) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.networkError)
            XCTAssertNil(exchangeRates)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRatesShouldPostFailedCallbackIfNoData() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            exchangeRateSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (errorCode, exchangeRates) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.networkError)
            XCTAssertNil(exchangeRates)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRatesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            exchangeRateSession: URLSessionFake(
                data: FakeResponseData.exchangeRatesCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (errorCode, exchangeRates) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.httpResponseError)
            XCTAssertNil(exchangeRates)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetExchangeRatesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            exchangeRateSession: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (errorCode, exchangeRates) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.incorrectDataStruct)
            XCTAssertNil(exchangeRates)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.10)
    }

    func testGetExchangeRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            exchangeRateSession: URLSessionFake(
                data: FakeResponseData.exchangeRatesCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (errorCode, exchangeRates) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.none)
            XCTAssertNotNil(exchangeRates)

            XCTAssertTrue(exchangeRates!.success)
            XCTAssertEqual("EUR", exchangeRates!.base)
            XCTAssertEqual(exchangeRates!.rates?.usd, 1.189195)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
func testGetExchangeRatesGivenPostSuccessCallbackIfNoErrorAndCorrectData() {
    }
}
