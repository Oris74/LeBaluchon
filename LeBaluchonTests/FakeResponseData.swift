//
//  File.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
    static var exchangeRatesCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Fixer", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static var translationCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "GoogleTranslate", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static var weatherCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "OpenWeathermap", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    static let incorrectData = "erreur".data(using: .utf8)!

    static let imageData = "image".data(using: .utf8)!

    // MARK: - Response
    static let responseOK = HTTPURLResponse(
        url: URL(string: "http://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!

    static let responseKO = HTTPURLResponse(
        url: URL(string: "http://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!


    // MARK: - Error
    class ErrorClass: Error {}
    static let error = ErrorClass()
}


