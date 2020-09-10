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

    private var task: URLSessionDataTask?

    private var session = URLSession(configuration: .default)

    private var apiKey = "API_Fixer"

    init(exchangeRateSession: URLSession = URLSession(configuration: .default),
         apiKey: String = "API_Fixer") {
        self.session = exchangeRateSession
        self.apiKey = apiKey
        super.init()
    }

    private  let exchangeRateUrl =
        URL(string:
            "http://data.fixer.io/api/latest")!

    ///entry point for data importation  of exchange rate conversion module
    func getExchangeRate(callback: @escaping (Utilities.ManageError?, ExchangeRates?) -> Void) {

        guard let keyFixer = Utilities.getValueForAPIKey(named: apiKey) else {
            callback(Utilities.ManageError.apiKeyError, nil)
            return
        }

        let queryItems = [URLQueryItem(name: "access_key", value: keyFixer)]

        let request = createRequest(url: exchangeRateUrl, queryItems: queryItems)

        // prevent two identical tasks
        task?.cancel()

        task = session.dataTask(with: request) {[weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.carryOutData(
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
