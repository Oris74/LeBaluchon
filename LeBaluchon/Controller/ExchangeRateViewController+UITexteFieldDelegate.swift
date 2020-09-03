//
//  ExchangeRateViewController+UITexteFieldDelegate.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 27/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//
import UIKit

// MARK: - Keyboard

extension ExchangeRateViewController: UITextFieldDelegate {
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        currentAmount.resignFirstResponder()
    }

    private func textFieldShouldReturn(_ textField: UITextField) throws -> Bool {
        textField.resignFirstResponder()
        dismissKeyboard()
        guard let valueAmount = textField.text else { return true }

        do {
            try conversionValue(value: valueAmount)
        } catch let error as Utilities.ManageError {
            presentAlert(message: error.rawValue)
        }
        return true
    }
}
