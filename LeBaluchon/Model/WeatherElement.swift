//
//  WeatherElement.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - WeatherElement
///part of OpenWeather Data Structure
struct WeatherElement: Codable {
    let identifiant: Int
    let main, weatherDescription, icon: String
    enum CodingKeys: String, CodingKey {
        case identifiant = "id"
        case weatherDescription = "description"
        case main
        case icon
       }
}
