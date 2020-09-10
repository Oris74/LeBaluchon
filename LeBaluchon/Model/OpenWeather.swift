//
//  Weather.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Weather
/// API openweathermap.org Data Structure
struct OpenWeather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    // let base: String
    let main: Main
    // let visibility: Int
    // let wind: Wind
    // let clouds: Clouds
    // let dt: Int
    let sys: Sys
    // let timezone, id: Int
    let name: String
    let cod: Int
}
