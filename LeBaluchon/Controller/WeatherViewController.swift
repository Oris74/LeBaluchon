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
        vacationPlacePictoTemperature.image = UIImage(named: "Thermometer.png")
        localPlacePictoTemperature.image = UIImage(named: "Thermometer.png")
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        checkLocationServices()
        locationManager.startUpdatingLocation()
        if let location = locationManager.location?.coordinate {
            currentPlace = .coord(Coord(lon: location.longitude, lat: location.latitude))
        } else {
            manageErrors(errorCode: .missingCoordinate)
        }

        weather(place: vacationPlace, completionHandler: {[weak self] weather in
            self?.updateVacationPlace(weather: weather)
        })

        weather(place: currentPlace, completionHandler: {[weak self] weather in
            do {
                try self?.updateCurrentPlace(weather: weather)

            } catch let error as Utilities.ManageError {
                self?.manageErrors(errorCode: error)
            } catch {
                self?.manageErrors(errorCode: Utilities.ManageError.undefinedError)
            }
        })
    }

    func weather(place: Location, completionHandler: @escaping ( OpenWeather) -> Void) {
        toggleActivityIndicator(shown: true, place: place)

        WeatherService.shared.getWeather(place: place, callback: {[weak self] (errorCode, weather) in
            if errorCode == nil, let weather = weather {
                completionHandler(weather)
            } else {
                self?.manageErrors(errorCode: errorCode)
            }
            self?.toggleActivityIndicator(shown: false, place: place)
        })
    }

    ///refresh the view with the  datas of New York
    private func updateVacationPlace(weather: OpenWeather) {
        let pictoCode = weather.weather[0].icon

        //getting the right weather picto from openweather
        let urlPicto = URL(string: "http://openweathermap.org/img/wn/\(pictoCode)@2x.png")
        vacationPlaceWeatherPicto.load(url: urlPicto!)

        vacationPlaceLabel.text = weather.name

        vacationPlaceCoordinate.text =
        "Longitude: \(String(format: "%.2f", weather.coord.lon)) /" +
        " Latitude: \(String(format: "%.2f", weather.coord.lat))"

        vacationPlaceTemperatureLabel.text = String(weather.main.temp) + "°C"
        vacationWeatherDescription.text = weather.weather[0].weatherDescription
    }

    ///refresh the view with the  datas of the current location
    private func updateCurrentPlace(weather: OpenWeather) throws {
        guard case .coord(let coord) = currentPlace, coord.lat != 0.0 else {
            localCoordinate.text = "Longitude: ? / Latitude: ?"
            throw Utilities.ManageError.missingCoordinate
        }

        let pictoCode = weather.weather[0].icon
        let urlPicto = URL(string: "http://openweathermap.org/img/wn/"+pictoCode+"@2x.png")
        localPlacePictoWeather.load(url: urlPicto!)

        localPlaceLabel.text = weather.name

        localCoordinate.text =
        "Longitude: \(String(format: "%.2f", coord.lon)) " +
        "/ Latitude: \(String(format: "%.2f", coord.lat))"

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
