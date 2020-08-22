//
//  TranslationServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 20/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import XCTest

@testable import LeBaluchon

class TranslationServiceTestCase: XCTestCase {
    let textToTranslate = """
The Great Pyramid of Giza (also known as the Pyramid of Khufu or the Pyramid of Cheops) is the oldest and largest of the
 three pyramids in the Giza pyramid complex.
"""
    let textTranslated = """
La Grande Pyramide de Gizeh (également connue sous le nom de Pyramide de Khéops ou Pyramide de Khéops) est la plus ancienne et la plus grande des trois pyramides du complexe pyramidal de Gizeh.
"""
    let source = "en"
    let target = "fr"

    func testGetTranslationShouldPostFailedCallback() {
        // Given
        let translationService = TranslationService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(
            text: textToTranslate, source: source, target: target, callback: { (success, translate) in
                // Then
                XCTAssertFalse(success)
                XCTAssertNil(translate)
                expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfNoData() {
        // Given
        let translationService = TranslationService(
            session: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(
            text: textToTranslate, source: source, target: target, callback: { (success, translate) in
                // Then
                XCTAssertFalse(success)
                XCTAssertNil(translate)
                expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let translationService = TranslationService(
            session: URLSessionFake(
                data: FakeResponseData.exchangeRatesCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(
            text: textToTranslate, source: source, target: target, callback: { (success, translate) in
                // Then
                XCTAssertFalse(success)
                XCTAssertNil(translate)
                expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let translationService = TranslationService(
            session: URLSessionFake(
                data: FakeResponseData.incorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        translationService.getTranslation(
            text: textToTranslate, source: source, target: target, callback: { (success, translate) in
                // Then
                XCTAssertFalse(success)
                XCTAssertNil(translate)
                expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetTranslationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let translationService = TranslationService(
            session: URLSessionFake(
                data: FakeResponseData.translationCorrectData,
                response: FakeResponseData.responseOK,
                error: nil))

        // When
        let expectation = XCTestExpectation(
            description: "Wait for queue change.")
        translationService.getTranslation(
            text: textToTranslate, source: source, target: target, callback: { (success, translate) in
                // Then
                XCTAssertTrue(success)
                XCTAssertNotNil(translate)

                XCTAssertNotNil(translate?.data.translations[0].translatedText)
                XCTAssertEqual(translate?.data.translations[0].translatedText, self.textTranslated)
                expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
