//
//  WeatherViewController+CLLocationManagerDelegate.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 26/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit
import CoreLocation

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
