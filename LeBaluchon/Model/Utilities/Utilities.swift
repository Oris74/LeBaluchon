//
//  Utilities.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 29/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Utilities

class Utilities {
    enum ManageError: String, Error {
        case missingCoordinate = "Coordonnées GPS indisponibles"
        case keyboardError = "veuillez saisir des valeurs numériques"
        case incorrectDataStruct = "la structure n'est pas conforme aux données API"
        case httpResponseError
        case networkError = "Problème d'acces au site"
        case none
    }

    static func getValueForAPIKey(named keyname: String) -> String? {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)

        let value = plist?.object(forKey: keyname) as? String

        return value
    }
}
