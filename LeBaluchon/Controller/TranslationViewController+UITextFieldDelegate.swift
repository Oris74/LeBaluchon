//
//  TranslationViewController+UITextFieldDelegate.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 27/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit

extension TranslationViewController: UITextViewDelegate {

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceText.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        textField.resignFirstResponder()
        return true
    }
}
