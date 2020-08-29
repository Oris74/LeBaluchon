//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, VCUtilities {

    var locationManager = CLLocationManager()
    var currentPlace: Location
    let vacationPlace: Location

    enum WeatherError: String, Error {
        case coordinateMissing = "Coordonnées GPS indisponibles"
        case impossibleGettingData = "Problème dans la récupération des données"
    }

    @IBOutlet weak var vacationPlaceLabel: UILabel!
    @IBOutlet weak var vacationPlaceWeatherPicto: UIImageView!
    @IBOutlet weak var vacationPlacePictoTemperature: UIImageView!
    @IBOutlet weak var vacationPlaceCoordinate: UILabel!
    @IBOutlet weak var vacationWeatherDescription: UILabel!
    @IBOutlet weak var vacationPlaceTemperatureLabel: UILabel!
    @IBOutlet weak var vacationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var localPlaceLabel: UILabel!
    @IBOutlet weak var localPlacePictoWeather: UIImageView!
    @IBOutlet weak var localPlacePictoTemperature: UIImageView!
    @IBOutlet weak var localWeatherDescription: UILabel!
    @IBOutlet weak var localCoordinate: UILabel!

    @IBOutlet weak var localActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var localPlaceTemperatureLabel: UILabel!

    required init?(coder: NSCoder) {
        self.currentPlace = .coord(Coord(lon: 0.0, lat: 0.0))
        self.vacationPlace = .town("New York", "us")
        super.init(coder: coder)

    }

    override func viewDidLoad() {
        toggleActivityIndicator(shown: false)
        checkLocationServices()
        vacationPlacePictoTemperature.image = UIImage(named: "Thermometer.png")
        localPlacePictoTemperature.image = UIImage(named: "Thermometer.png")
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        if let location = locationManager.location?.coordinate {
            currentPlace = .coord(Coord(lon: location.longitude, lat: location.latitude))
        }

        weather(place: vacationPlace, completionHandler: { weather in
            do {
                try self.updateVacationPlace(weather: weather)

            } catch let error as WeatherViewController.WeatherError {
                self.presentAlert(message: error.rawValue)
            } catch {
                self.presentAlert(message: "oups indefined error" )
            }
        })

        weather(place: currentPlace, completionHandler: { weather in
            do {
                try self.updateCurrentPlace(weather: weather)

            } catch let error as WeatherViewController.WeatherError {
                self.presentAlert(message: error.rawValue)
            } catch {
                self.presentAlert(message: "oups indefined error" )
            }
        })

    }

    func weather(place: Location, completionHandler: @escaping (OpenWeather) -> Void) {
        self.toggleActivityIndicator(shown: true, place: place)
        WeatherService.shared.getWeather(place: place, callback: {(success, weather) in
            if success, let weather = weather {
                completionHandler(weather)
            } else {
                self.presentAlert(message: "récupération des données impossible")
            }
            self.toggleActivityIndicator(shown: false, place: place)
        })
    }

    private func updateVacationPlace(weather: OpenWeather) throws {
        let pictoCode = weather.weather[0].icon
        let urlPicto = URL(string: "http://openweathermap.org/img/wn/"+pictoCode+"@2x.png")
        vacationPlaceWeatherPicto.load(url: urlPicto! )

        vacationPlaceLabel.text = weather.name

        vacationPlaceCoordinate.text = "Longitude: \(weather.coord.lon) / Latitude: \(weather.coord.lat)"

        vacationPlaceTemperatureLabel.text = String(weather.main.temp) + "°C"
        vacationWeatherDescription.text = weather.weather[0].weatherDescription
    }

    private func updateCurrentPlace(weather: OpenWeather) throws {
        let pictoCode = weather.weather[0].icon
        let urlPicto = URL(string: "http://openweathermap.org/img/wn/"+pictoCode+"@2x.png")
        localPlacePictoWeather.load(url: urlPicto! )

        localPlaceLabel.text = weather.name

        guard case .coord(let coord) = currentPlace else {
            localCoordinate.text = "Longitude: ? / Latitude: ?"
            throw WeatherError.coordinateMissing
        }
        localCoordinate.text = "Longitude: \(coord.lon) / Latitude: \(coord.lat)"

        localPlaceTemperatureLabel.text = String(weather.main.temp) + "°C"
        localWeatherDescription.text = weather.weather[0].weatherDescription
    }

    private func toggleActivityIndicator(shown: Bool, place: Location? = nil ) {
        switch place {
        case .coord:
            localActivityIndicator.isHidden = !shown
        case .town:
            vacationActivityIndicator.isHidden = !shown
        case nil:
            localActivityIndicator.isHidden = !shown
            vacationActivityIndicator.isHidden = !shown
        }
    }
}
