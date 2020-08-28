//
//  Services.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 26/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation
class NetworkServices {
   var session = URLSession(configuration: .default)
   

    func createRequest(url: URL, methode: String = "GET", queryItems: [String: String?]) -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!

        components.queryItems = queryItems.map {
            URLQueryItem(name: $0, value: $1)
        }

        print(components.url!)
        var request = URLRequest(url: components.url!)
        request.httpMethod = methode
        return request
    }

   }
