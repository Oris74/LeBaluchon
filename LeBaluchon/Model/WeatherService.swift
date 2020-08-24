//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

class WeatherService {

    static let shared = WeatherService()
    private init() {}

    private var task: URLSessionDataTask?

    private var weatherSession = URLSession(configuration: .default)

    private var location: Location?
    private var request: URLRequest?

    init(location: Location, session: URLSession? = nil) {
        if let sessionLocation = session {
            self.weatherSession = sessionLocation
        }
        let request = self.createWeatherRequest(location: location)
        self.request = request
    }

    init(coord: Coord, session: URLSession? = nil) {
        if let sessionCoord = session {
            self.weatherSession = sessionCoord
        }
        let request = createWeatherRequest(coordinate: coord)
        self.request = request
    }
    
    private  let openWeathermapUrl = URL(string: "api.openweathermap.org/data/2.5/weather?")!

    func getWeather( callback: @escaping (Bool, OpenWeather?) -> Void) {
        task?.cancel()
        task = weatherSession.dataTask(with: self.request!) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let weather = try? JSONDecoder().decode(OpenWeather.self, from: data) else {
                    callback(false, nil)
                    return
                }

                callback(true, weather)
            }
        }
        task?.resume()
    }

    private func createWeatherRequest(location: Location) -> URLRequest {
        var components = URLComponents(url: openWeathermapUrl, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "appid", value: "bb40a38a8c8520cc06a6df6efe45cef1"),
            URLQueryItem(name: "q", value: location.town + "," + location.country )
        ]

        let query = components.url!.query

        var request = URLRequest(url: openWeathermapUrl)
        request.httpMethod = "GET"
        request.httpBody = query!.data(using: .utf8)
        return request
    }

    private func createWeatherRequest(coordinate: Coord) -> URLRequest {
        var components = URLComponents(url: openWeathermapUrl, resolvingAgainstBaseURL: false)!

        components.queryItems = [
            URLQueryItem(name: "lon", value: String(coordinate.lon)),
            URLQueryItem(name: "lat", value: String(coordinate.lat)),
            URLQueryItem(name: "appid", value: "bb40a38a8c8520cc06a6df6efe45cef1")
        ]

        let query = components.url!.query

        var request = URLRequest(url: openWeathermapUrl)
        request.httpMethod = "GET"
        request.httpBody = query!.data(using: .utf8)
        return request
    }
}
