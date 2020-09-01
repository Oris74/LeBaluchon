//
//  Location+Equitable.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 26/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {

        switch (lhs, rhs) {

        case (.town(let townNameA, let countryNameA), let .town(townNameB, countryNameB))
            where (townNameA == townNameB) && (countryNameA == countryNameB):
            return true

        case (.coord(let coordinateA), .coord(let coordinateB))
            where (coordinateA.lat == coordinateB.lat) && (coordinateA.lon == coordinateB.lon):
            return true

        default:
            return false
        }
    }
}
