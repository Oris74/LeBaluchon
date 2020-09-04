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
            weatherSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: { (errorCode, weather) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.networkError)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherByLocationShouldPostFailedCallbackIfNoData() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(data: nil, response: nil, error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: { (errorCode, weather) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.networkError)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherByLocationShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let weatherService = WeatherService(
            weatherSession: URLSessionFake(
                data: FakeResponseData.weatherCorrectData,
                response: FakeResponseData.responseKO,
                error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: {(errorCode, weather) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.httpResponseError)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(
            data: FakeResponseData.incorrectData,
            response: FakeResponseData.responseOK,
            error: nil))
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: {(errorCode, weather) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.incorrectDataStruct)
            XCTAssertNil(weather)
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetWeatherGivenTownLocationShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(
            data: FakeResponseData.weatherCorrectData,
            response: FakeResponseData.responseOK,
            error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: locationTest, callback: {(errorCode, weather) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.none)
            XCTAssertNotNil(weather)
            if case .town(let townName, _) = self.locationTest {
                XCTAssertEqual(weather?.name, townName)
            }
            XCTAssertEqual(weather?.weather[0].main, "Clouds" )
            XCTAssertEqual(weather?.weather[0].icon, "04d" )
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
    func testGetWeatherGivenCoordonateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let weatherService = WeatherService(weatherSession: URLSessionFake(
            data: FakeResponseData.weatherCorrectData,
            response: FakeResponseData.responseOK,
            error: nil))

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        weatherService.getWeather(place: coordinateTest, callback: {(errorCode, weather) in
            // Then
            XCTAssertEqual(errorCode, Utilities.ManageError.none)
            XCTAssertNotNil(weather)
            if case .town(let townName, _) = self.locationTest {
                XCTAssertEqual(weather?.name, townName)
            }
            XCTAssertEqual(weather?.weather[0].main, "Clouds" )
            XCTAssertEqual(weather?.weather[0].icon, "04d" )
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 0.01)
    }
}
