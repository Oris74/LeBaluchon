//
//  ExchangeRates.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - ExchangeRates
///API Fixer.io Data Structure
struct ExchangeRates: Codable {

    let success: Bool
    // let timestamp: Int
    let base, date: String
    let rates: Rates?

    var euroAmount: Double?
    var euroToDollar: Double? {
        let rate = rates?.usd ?? 0.0
        let amount = euroAmount ?? 0.0
        return rate * amount
    }
}
