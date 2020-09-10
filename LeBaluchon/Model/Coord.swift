//
//  Coord.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Coord
///part of OpenWeather Data Structure
struct Coord: Hashable, Codable {
    let lon, lat: Double
}
