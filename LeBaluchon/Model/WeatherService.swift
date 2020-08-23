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

       private  let openWeathermapUrl = URL(string: "api.openweathermap.org/data/2.5/weather?")!

       func getWeather(text: String, source: String, target: String, callback: @escaping (Bool, Weather?) -> Void) {
           let request = createWeatherRequest(text: text, source: source, target: target)

           task?.cancel()

           task = weatherSession.dataTask(with: request) { (data, response, error) in
               DispatchQueue.main.async {
                   guard let data = data, error == nil else {
                       callback(false, nil)
                       return
                   }

                   guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                       callback(false, nil)
                       return
                   }

                   guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                       callback(false, nil)
                       return
                   }

                   callback(true, weather)
               }
           }
           task?.resume()
       }

       private func createWeatherRequest(text: String, source: String, target: String) -> URLRequest {
           var components = URLComponents(url: openWeathermapUrl, resolvingAgainstBaseURL: false)!

           components.queryItems = [
               URLQueryItem(name: "appid", value: "bb40a38a8c8520cc06a6df6efe45cef1"),
               URLQueryItem(name: "q", value: text)
           ]

           let query = components.url!.query

           var request = URLRequest(url: openWeathermapUrl)
           request.httpMethod = "GET"
           request.httpBody = query!.data(using: .utf8)
           return request
       }
}
