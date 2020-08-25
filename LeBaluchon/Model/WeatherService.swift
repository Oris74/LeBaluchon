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
    init(session: URLSession) {
        self.weatherSession = session
    }
    private let openWeathermapUrl = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
    
    func getWeather(place: Location, callback: @escaping (Bool, OpenWeather?) -> Void) {
        let request = createWeatherRequest(location: place)
        //task.cancel()
        task = weatherSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                print("data: \(data)")
                print("error: \(data)")
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
        task?.resume()
    }
    
    private func createWeatherRequest(location: Location) -> URLRequest {
        var components = URLComponents(url: openWeathermapUrl, resolvingAgainstBaseURL: false)!
        var queryItems = [URLQueryItem]()
       
        switch location {
        case .coord(let coordinatePlace):
            queryItems.append(URLQueryItem(name: "lat", value: String(coordinatePlace.lat)))
            queryItems.append(URLQueryItem(name: "lon", value: String(coordinatePlace.lon)))
        case .town( let townName, let countryName):
            queryItems.append(URLQueryItem(name: "q", value: "\(townName),\(countryName)"))
        }
       
        queryItems.append(URLQueryItem(name: "appid", value: "bb40a38a8c8520cc06a6df6efe45cef1"))
        queryItems.append(URLQueryItem(name: "lang", value: "fr"))
        queryItems = queryItems.filter { !$0.name.isEmpty }
        components.queryItems = queryItems
        print(components.url!)
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
}
