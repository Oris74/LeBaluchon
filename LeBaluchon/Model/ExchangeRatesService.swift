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
    private override init() {}

    private var task: URLSessionDataTask?

    init(exchangeRateSession: URLSession) {
        super.init()
        self.session = exchangeRateSession
    }

    private  let exchangeRateUrl =
        URL(string:
            "http://data.fixer.io/api/latest")!

    private var queryItems: [String: String?] =
        ["access_key": nil]

    func getExchangeRate(callback: @escaping (Bool, ExchangeRates?) -> Void) {
        let keyFixer = Utilities.getValueForAPIKey(named: "API_Fixer")
        queryItems["access_key"] = keyFixer
        let request = createRequest(url: exchangeRateUrl, methode: "GET", queryItems: queryItems)

        task?.cancel()

        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                print("response: \(response)")
                do {
                    guard let exchangeRates = try JSONDecoder().decode(ExchangeRates?.self, from: data) else {
                        callback(false, nil)
                        return
                    }
                    callback(true, exchangeRates)
                } catch let error {
                    if let decodingError = error as? DecodingError {
                        print("Error coverting: ", decodingError)
                    }
                }
            }
        }
        task?.resume()
    }
}
