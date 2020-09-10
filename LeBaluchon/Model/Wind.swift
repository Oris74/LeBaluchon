//
//  Wind.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Wind
///part of OpenWeather Data Structure
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
