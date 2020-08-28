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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismissKeyboard()
        conversionValue()
        return true
    }
}
