//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

class WeatherService: NetworkServices {
    static let shared = WeatherService()
    override private init() {}

    private var session = URLSession(configuration: .default)

    private var task: [Location: URLSessionDataTask?] = [:]

    private let openWeathermapUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather")!

    init(weatherSession: URLSession) {
        self.session = weatherSession
    }

    func getWeather(place: Location, callback: @escaping (Utilities.ManageError, OpenWeather?) -> Void) {
        let query = buildQueryItems(place: place)
        let request = createRequest(url: openWeathermapUrl, queryItems: query)

        if let currentTask = task[place] {
            currentTask?.cancel()
        }

        task[place] = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.carryOutData(
                    OpenWeather?.self,
                    data, response, error,
                    completionHandler: {(weather, errorCode) in
                        callback(errorCode, weather)
                })
            }
        }

        if let currentTask = task[place] {
            currentTask?.resume()
        }
    }

    private func buildQueryItems(place: Location) -> [URLQueryItem] {
        let keyOpenWeathermap = Utilities.getValueForAPIKey(named: "API_OpenWeathermap")
        var query = [
            URLQueryItem(name: "appid", value: keyOpenWeathermap),
            URLQueryItem(name: "lang", value: "fr"),
            URLQueryItem(name: "units", value: "metric")
        ]

        switch place {
        case .coord(let coordinatePlace):
            query.append(URLQueryItem(name: "lat", value: String(coordinatePlace.lat)))
            query.append(URLQueryItem(name: "lon", value: String(coordinatePlace.lon)))
        case .town( let townName, let countryName):
            query.append(URLQueryItem(name: "q", value: "\(townName),\(countryName)"))
        }
        return query
    }
}
