//
//  ExchangeRates.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - ExchangeRates
struct ExchangeRates: Codable {
    let success: Bool
    let timestamp: Int
    let base, date: String
    let rates: Rates?
    var euroAmount: Double?
    var euroToDollar: Double? {
        guard let rate = rates?.usd else { return nil }
        guard let amount = euroAmount else { return nil }
        return rate * amount
    }
}
