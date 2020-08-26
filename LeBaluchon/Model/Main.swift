//
//  Main.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}
