//
//  Sys.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Sys
///part of OpenWeather Data Structure
struct Sys: Codable {
    let type, identifiant: Int
    let country: String
    let sunrise, sunset: Int
    enum CodingKeys: String, CodingKey {
           case type
           case identifiant = "id"
           case country
           case sunrise
           case sunset
       }
}
