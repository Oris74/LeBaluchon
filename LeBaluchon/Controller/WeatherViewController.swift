//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    var locationManager = CLLocationManager()
    var currentPlace: Location
    let vacationPlace: Location
    
    @IBOutlet weak var vacationPlaceLabel: UILabel!
    @IBOutlet weak var weatherVacationPlacePicto: UIImageView!
    @IBOutlet weak var temperatureVacationPlace: UIImageView!
    @IBOutlet weak var localPlaceLabel: UILabel!
    @IBOutlet weak var localWeatherPlacePicto: UIImageView!
    @IBOutlet weak var temperatureLocalPlace: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var localCoordinate: UILabel!
    @IBOutlet weak var vacationCoordinateLocation: UILabel!

    required init?(coder: NSCoder) {
        //self.currentPlace = .coord
        self.vacationPlace = .town("New York", "us")
        super.init(coder: coder)

    }
    
    override func viewDidLoad() {
        toggleActivityIndicator(shown: false)
        checkLocationServices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        if let location = locationManager.location?.coordinate {
            currentPlace = .coord(Coord(lon:location.longitude, lat:location.latitude))
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        weather(place: vacationPlace, completionHandler: { weather in
            self.updateVacationPlace(weather: weather)
        })
        weather(place: currentPlace, completionHandler: { weather in
            do {
                try self.updateCurrentPlace(weather: weather)
            } catch let error as WeatherViewController.NetworkError {
                presentAlert(message: error)
            }
        }) 
    }

    func weather(place: Location, completionHandler: @escaping (OpenWeather) -> Void) {
        WeatherService.shared.getWeather(place: place, callback: {(success, weather) in
            if success, let weather = weather {
                completionHandler(weather)
            } else {
                self.presentAlert(message: "récupération des données impossible")
            }
            self.toggleActivityIndicator(shown: false)
        })
    }

    private func updateVacationPlace(weather: OpenWeather) {
        let pictoCode = weather.weather[0].icon
        let urlPicto = URL(string: "http://openweathermap.org/img/wn/"+pictoCode+"@2x.png")
        
        vacationPlaceLabel.text = weather.name
        vacationCoordinateLocation.text = "Longitude: \(weather.coord.lon) / Latitude: \(weather.coord.lat)"
        
        weatherVacationPlacePicto.load(url: urlPicto! )
        temperatureVacationPlace.image = UIImage(named: "temperate.png")
    }

    private func updateCurrentPlace(weather: OpenWeather) throws {
        localPlaceLabel.text = weather.name
        guard case .coord(let coord) = currentPlace else {
            localCoordinate.text = "Longitude: ? / Latitude: ?"
            throw NetworkError.coordinateMissing
        }
        
        localCoordinate.text = "Longitude: \(coord.lon) / Latitude: \(coord.lat)"
        
        let pictoCode = weather.weather[0].icon
        let urlPicto = URL(string: "http://openweathermap.org/img/wn/"+pictoCode+"@2x.png")
        localWeatherPlacePicto.load(url: urlPicto! )
        
        temperatureLocalPlace.image = UIImage(named: "temperate.png")
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }

    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            presentAlert(message: "Géolocalisation Impossible")
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
           break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            break
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    enum NetworkError: Error {
        case coordinateMissing
        case orderIsEmpty
        case invalidPaymentMethod
        case insufficientFundings
    }
}
