//
//  VCUtilities.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 29/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit

protocol VCUtilities: UIViewController {
    func presentAlert(message: String)
}

extension VCUtilities {

    internal func presentAlert(message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    internal func dismissKeyboard() {
        view.endEditing(true)
    }

    func manageErrors(errorCode: Utilities.ManageError?) {
        guard let error = errorCode else {
            presentAlert(message: Utilities.ManageError.undefinedError.rawValue)
            return
        }
        presentAlert(message: error.rawValue)
    }
}
