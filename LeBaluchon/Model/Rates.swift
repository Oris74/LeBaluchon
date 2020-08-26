//
//  Rates.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 19/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Rates
struct Rates: Codable {
    let usd: Double

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}
