//
//  ExchangeRateViewController.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController {
    @IBOutlet weak var convertedAmount: UITextField!
    @IBOutlet weak var currentAmount: UITextField!
    @IBOutlet weak var currentRate: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBAction func conversionButtonTapped(_ sender: UIButton) {
        guard let amount = currentAmount.text else { return }

        toggleActivityIndicator(shown: true)

        ExchangeRatesService.shared.getExchangeRate { (success, exchangeRate) in
            if success, var exchangeRate = exchangeRate {
                exchangeRate.euroAmount = Double(amount)
                self.update(exchangeRate: exchangeRate)
            } else {
                self.toggleActivityIndicator(shown: false)
                self.presentAlert(message: "récupération des données impossible")
            }
        }
    }

    override func viewDidLoad() {
        toggleActivityIndicator(shown: false)
    }

    private func update(exchangeRate: ExchangeRates) {

        currentRate.text = String(exchangeRate.rates?.usd ?? 0.0)
        convertedAmount.text =  String(exchangeRate.euroToDollar ?? 0.0)

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
