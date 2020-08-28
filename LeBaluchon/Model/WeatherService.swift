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
    private override init() {}
    var task: [Location: URLSessionDataTask?] = [:]
    private let openWeathermapUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather")!

    let commonQueryItems: [String: String?] =
        ["appid": "bb40a38a8c8520cc06a6df6efe45cef1",
         "lang": "fr",
         "units": "metric"]
    var coordonateQuery: [String: String?] =
        ["lat": nil,
         "lon": nil]
    var locationQueryItems: [String: String?] =
        ["q": nil]

    let httpMethode = "GET"

    init(weatherSession: URLSession) {
        super.init()
        self.session = weatherSession
    }

    func getWeather(place: Location, callback: @escaping (Bool, OpenWeather?) -> Void) {
        let query = createQuery(place: place)
        let request = createRequest(url: openWeathermapUrl, methode: httpMethode, queryItems: query)

        if let currentTask=task[place] {
            currentTask?.cancel()
        }
        task[place] = session.dataTask(with: request) { (data, response, error) in
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
                    guard let weather = try JSONDecoder().decode(OpenWeather?.self, from: data) else {
                        callback(false, nil)
                        return
                    }
                    callback(true, weather)
                } catch let error {
                    if let decodingError = error as? DecodingError {
                        print("Error coverting: ", decodingError)
                    }
                }
            }
        }
        if let currentTask = task[place] {
            currentTask?.resume()
        }
    }

    private func createQuery(place: Location) -> [String: String?] {
        var query = commonQueryItems

        switch place {
        case .coord(let coordinatePlace):
            coordonateQuery["lat"] = String(coordinatePlace.lat)
            coordonateQuery["lon"] = String(coordinatePlace.lon)
            query.merge(coordonateQuery) {(current, _) in current}

        case .town( let townName, let countryName):
            locationQueryItems["q"] = "\(townName),\(countryName)"
            query.merge(locationQueryItems) {(current, _) in current}
        }
        return query
    }
}
