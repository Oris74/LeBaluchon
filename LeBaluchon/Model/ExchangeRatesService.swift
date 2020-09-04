//
//  ExchangeRatesService.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

class ExchangeRatesService: NetworkServices {

    static let shared = ExchangeRatesService()

    override init() {}

    private var task: URLSessionDataTask?

    private var session = URLSession(configuration: .default)

    init(exchangeRateSession: URLSession) {
        self.session = exchangeRateSession
    }

    private  let exchangeRateUrl =
        URL(string:
            "http://data.fixer.io/api/latest")!

    func getExchangeRate(callback: @escaping (Utilities.ManageError, ExchangeRates?) -> Void) {
        guard let keyFixer = Utilities.getValueForAPIKey(named: "API_Fixer") else { return }
        let queryItems = [URLQueryItem(name: "access_key", value: keyFixer)]

        let request = createRequest(url: exchangeRateUrl, queryItems: queryItems)

        task?.cancel()

        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.carryOutData(
                    ExchangeRates?.self,
                    data, response, error,
                    completionHandler: {(exchangeRates, errorCode) in
                    callback(errorCode, exchangeRates)
                })
            }
        }
        task?.resume()
    }
}
