//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    var currentPlace: Coord
    let vacationPlace: Location
   
    @IBOutlet weak var vacationPlaceLabel: UILabel!

    @IBOutlet weak var weatherVacationPlacePicto: UIImageView!

    @IBOutlet weak var temperatureVacationPlace: UIImageView!

    @IBOutlet weak var currentLocationLabel: UILabel!

    @IBOutlet weak var weatherCurrentLocation: UIImageView!

    @IBOutlet weak var temperatureCurrentLocation: UIImageView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    required init?(coder: NSCoder) {
               
        self.currentPlace = Coord(lon: 0.0, lat: 0.0)
        self.vacationPlace = Location(town: "New York", country: "us")
                
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        toggleActivityIndicator(shown: false)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

    @IBAction func buttonTapped(_ sender: Any) {
        getWeather(place: vacationPlace)
        getWeather(place: currentPlace )
    }

    func getWeather(place: Location ) {
        toggleActivityIndicator(shown: false)
        let weatherService = WeatherService(
               location: place )
        weatherService.getWeather { (success, weather) in
            if success, let weather = weather {
                self.update(weather: weather)
            } else {
                self.toggleActivityIndicator(shown: false)
                self.presentAlert(message: "récupération des données impossible")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstCoordinate = locations.first else { return }
        currentPlace.lat = firstCoordinate.coordinate.latitude
        currentPlace.lon = firstCoordinate.coordinate.longitude
        
    }

    private func update(weather: OpenWeather) {

        currentLocationLabel.text = weather.name

        self.toggleActivityIndicator(shown: false)
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
