//
//  WeatherElement.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, description, icon: String
    
}
