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
    
    func testGetExchangeRatesShouldPostFailedCallback() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (success, ExchangeRates) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(ExchangeRates)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRatesShouldPostFailedCallbackIfNoData() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (success, ExchangeRates) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(ExchangeRates)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRatesShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            session: URLSessionFake(
                data: FakeResponseData.exchangeRatesCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (success, ExchangeRates) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(ExchangeRates)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRatesShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            session: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (success, ExchangeRates) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(ExchangeRates)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetExchangeRatesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let exchangeRatesService = ExchangeRatesService(
            session: URLSessionFake(
                data: FakeResponseData.exchangeRatesCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        exchangeRatesService.getExchangeRate { (success, ExchangeRates) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(ExchangeRates)
            
            XCTAssertTrue(ExchangeRates!.success)
            XCTAssertEqual("EUR", ExchangeRates!.base)
            XCTAssertEqual(ExchangeRates!.rates?.usd, 1.189195)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
