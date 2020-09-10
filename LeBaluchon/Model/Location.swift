//
//  Location.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

///identification of the places to be used for weather module
enum Location: Hashable {
    case town(TownName, CountryName)
    case coord(Coord)
    typealias TownName = String
    typealias CountryName = String
}
