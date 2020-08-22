//
//  ExchangeRatesService.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

class ExchangeRatesService {
    static let shared = ExchangeRatesService()
    private init() {}

    private var task: URLSessionDataTask?
    private var exchangeRateSession = URLSession(configuration: .default)

    init(session: URLSession) {
        self.exchangeRateSession = session
    }

    private  let exchangeRateUrl =
        URL(string:
            "http://data.fixer.io/api/latest?access_key=2e59286d64809e5f0d78a74a37ba71d7")!

    func getExchangeRate(callback: @escaping (Bool, ExchangeRates?) -> Void) {
        let request = createExchangeRateRequest()

        task?.cancel()

        task = exchangeRateSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let exchangeRates = try? JSONDecoder().decode(ExchangeRates.self, from: data) else {
                    callback(false, nil)
                    return
                }

                callback(true, exchangeRates)
            }
        }
        task?.resume()
    }

    private func createExchangeRateRequest() -> URLRequest {
        return  URLRequest(url: exchangeRateUrl)
    }
}
