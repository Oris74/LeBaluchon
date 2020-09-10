//
//  Utilities.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 29/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

// MARK: - Model Utilities

class Utilities {
    enum ManageError: String, Error {
        case apiKeyError = "Clef API non recupéré"
        case emptyText = "veuillez saisir un texte à traduire"
        case httpResponseError = "Réponse incorrect du serveur"
        case incorrectDataStruct = "la structure n'est pas conforme aux données API"
        case keyboardError = "veuillez saisir des valeurs numériques"
        case missingCoordinate = "Coordonnées GPS indisponibles"
        case networkError = "Problème d'acces au site"
        case undefinedError = "erreur non definie"
    }

    ///getting API keys from the ApiKeys.plist file located in 'Supporting Files' folder
    static func getValueForAPIKey(named keyname: String) -> String? {
        let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)

        let value = plist?.object(forKey: keyname) as? String

        return value
    }
}
