//
//  Utilities.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 29/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Utilities

class Utilities {
    static func getValueForAPIKey(named keyname: String) -> String {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)

        let value = plist?.object(forKey: keyname) as? String

        return value!
    }

    static func createRequest(url: URL, methode: String = "GET", queryItems: [String: String?]) -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        components.queryItems = queryItems.map {
            URLQueryItem(name: $0, value: $1)
        }

        var request = URLRequest(url: components.url!)
        request.httpMethod = methode
        return request
    }
}
