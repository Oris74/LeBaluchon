//
//  Location.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 23/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

enum Location {

    case town(TownName, CountryName)
    case coord(Coord)

    typealias TownName = String
    typealias CountryName = String
}
