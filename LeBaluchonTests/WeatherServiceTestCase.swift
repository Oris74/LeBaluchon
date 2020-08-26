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

    let locationTest = Location.town("Annecy", "fr")
    let coordinateTest = Location.coord(Coord(lon: 6.12, lat: 45.9))

    func testGetWeatherbyLocationShouldPostFailedCallback() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherByLocationShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: { (success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherByLocationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            session: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: {(success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(
            data: FakeResponseData.incorrectData,
            response: FakeResponseData.responseOK,
            error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: {(success, weather) in
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(session: URLSessionFake(
            data: FakeResponseData.weatherCorrectData,
            response: FakeResponseData.responseOK,
            error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: {(success, weather) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(weather)
            if case .town(let townName, _) = self.locationTest {
                XCTAssertEqual(weather?.name, townName)
            }
                XCTAssertEqual(weather?.weather[0].main, "Clouds" )
            XCTAssertEqual(weather?.weather[0].icon, "02d" )
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
