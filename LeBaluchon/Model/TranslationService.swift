//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

///main functions for Translation Module
class TranslationService: NetworkServices {
    static let shared = TranslationService()
    private let googleTranslateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2")

    private var task: URLSessionDataTask?

    private var session = URLSession(configuration: .default)

    private var apiKey = "API_GoogleTranslation"

    init(translationSession: URLSession = URLSession(configuration: .default),
         apiKey: String = "API_GoogleTranslation") {
        self.session = translationSession
        self.apiKey = apiKey
        super.init()
    }

    ///entry point for data importation  of translation module
    func getTranslation(
        text: String,
        source: String,
        target: String,
        callback: @escaping (Utilities.ManageError?, Translate?) -> Void) {

        guard let keyGoogleTranslate = Utilities.getValueForAPIKey(named: self.apiKey) else {
            callback(Utilities.ManageError.apiKeyError, nil)
            return
        }

        guard !text.isEmpty else {
            callback(Utilities.ManageError.emptyText, nil)
            return
        }

        let queryItems = buildQueryItems(key: keyGoogleTranslate, text: text, source: source, target: target)

        let request = createRequest(url: googleTranslateUrl!, methode: "POST", queryItems: queryItems)

        // prevent two identical tasks
        task?.cancel()

        task = session.dataTask(with: request) {[weak self] (data, response, error) in
            DispatchQueue.main.async {

                self?.carryOutData(
                    Translate?.self,
                    data, response, error,
                    completionHandler: {(translate, errorCode) in
                        callback(errorCode, translate)
                })
            }
        }
        task?.resume()
    }

    private func buildQueryItems(key: String, text: String, source: String, target: String) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "key", value: key),
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "target", value: target)
        ]
    }
}
