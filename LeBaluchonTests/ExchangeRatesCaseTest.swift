//
//  ExchangeRatesCaseTest.swift
//  LeBaluchonTests
//
//  Created by Laurent Debeaujon on 09/09/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import XCTest

@testable import LeBaluchon

class ExchangeRatesCaseTest: XCTestCase {

    func testExchangeRatesGivenUSRateWhenEuroAmountIs10ThenReturnDollarAmount() {
        //begin
        var exchangeRates = ExchangeRates(success: true, base: "", date: "", rates: Rates(usd: 1.18))

        //when
        exchangeRates.euroAmount = 10        //then
        XCTAssertEqual(exchangeRates.euroToDollar, 11.799999999999999)
    }

    func testExchangeRatesGivenUSRateEqualNilWhenEuroAmountIsNilThenReturnDollarAmountEqual0() {
        //begin
        var exchangeRates = ExchangeRates(success: true, base: "", date: "", rates: nil)

        //when
        exchangeRates.euroAmount = nil      //then
        XCTAssertEqual(exchangeRates.euroToDollar, 0.0)
    }

}
