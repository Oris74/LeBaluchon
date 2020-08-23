//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 20/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import XCTest

@testable import LeBaluchon

class WeatherServiceTestCase: XCTestCase {

    func testGetWeatherShouldPostFailedCallback() {
          // Given
          let weatherService = WeatherService(
              session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

          // When
          let expectation = XCTestExpectation(description: "Wait for queue change.")
          weatherService.getWeather { (success, weather) in
              // Then
              XCTAssertFalse(success)
              XCTAssertNil(weather)
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 0.01)
      }

      func testGetWeatherShouldPostFailedCallbackIfNoData() {
          // Given
          let weatherService = WeatherService(
              session: URLSessionFake(data: nil, response: nil, error: nil))

          // When
          let expectation = XCTestExpectation(description: "Wait for queue change.")
          WeatherService.getWeather { (success, weather) in
              // Then
              XCTAssertFalse(success)
              XCTAssertNil(Weather)
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 0.01)
      }

      func testGetWeatherShouldPostFailedCallbackIfIncorrectResponse() {
          // Given
          let weatherService = WeatherService(
              session: URLSessionFake(
                  data: FakeResponseData.weatherCorrectData,
                  response: FakeResponseData.responseKO,
                  error: nil))

          // When
          let expectation = XCTestExpectation(description: "Wait for queue change.")
          weatherService.getWeather { (success, weather) in
              // Then
              XCTAssertFalse(success)
              XCTAssertNil(weather)
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 0.01)
      }

      func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
          // Given
          let weatherService = WeatherService(
              session: URLSessionFake(
                  data: FakeResponseData.incorrectData,
                  response: FakeResponseData.responseOK,
                  error: nil))

          // When
          let expectation = XCTestExpectation(description: "Wait for queue change.")
          weatherService.getWeather { (success, weather) in
              // Then
              XCTAssertFalse(success)
              XCTAssertNil(weather)
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 0.01)
      }

      func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
          // Given
          let weatherService = WeatherService(
              session: URLSessionFake(
                  data: FakeResponseData.weatherCorrectData,
                  response: FakeResponseData.responseOK,
                  error: nil))

          // When
          let expectation = XCTestExpectation(description: "Wait for queue change.")
          weatherService.getWeather { (success, weather) in
              // Then
              XCTAssertTrue(success)
              XCTAssertNotNil(weather)

              XCTAssertTrue(weather!.success)
              XCTAssertEqual("EUR", weather!.base)
              XCTAssertEqual(weather!.rates?.usd, 1.189195)
              expectation.fulfill()
          }

          wait(for: [expectation], timeout: 0.01)
      }}
