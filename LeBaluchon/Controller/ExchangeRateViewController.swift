//
//  ExchangeRateViewController.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit

class ExchangeRateViewController: UIViewController, VCUtilities {
    @IBOutlet weak var convertedAmount: UITextField!
    @IBOutlet weak var currentAmount: UITextField!
    @IBOutlet weak var currentRate: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!

    @IBAction func conversionButtonTapped(_ sender: UIButton) {
        guard let tappedValue = currentAmount.text else { return }

        do {
        try conversionValue(value: tappedValue)
        } catch let errorCode as Utilities.ManageError {
            manageErrors(errorCode: errorCode)
        } catch {
            manageErrors(errorCode: .keyboardError)
        }
        dismissKeyboard()
    }

    override func viewDidLoad() {
        toggleActivityIndicator(shown: false)
        self.currentAmount.delegate = self
        super.viewDidLoad()
    }

    ///refresh the amount with the converted value
    private func update(exchangeRate: ExchangeRates) {

        currentRate.text = String(exchangeRate.rates?.usd ?? 0.0)
        convertedAmount.text =  String(format: "%.2f", exchangeRate.euroToDollar ?? 0.0)

        toggleActivityIndicator(shown: false)
    }

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        button.isUserInteractionEnabled = !shown
    }

    internal func conversionValue(value: String) throws {
        toggleActivityIndicator(shown: true)
        guard let amount = Double(value) else {
            throw Utilities.ManageError.keyboardError
        }

        ExchangeRatesService.shared.getExchangeRate {[weak self] (errorCode, exchangeRate) in
            if errorCode == nil, var exchangeRate = exchangeRate {
                exchangeRate.euroAmount = amount
                self?.update(exchangeRate: exchangeRate)
            } else {
                self?.toggleActivityIndicator(shown: false)
                self?.manageErrors(errorCode: errorCode)
            }
        }
    }
}
