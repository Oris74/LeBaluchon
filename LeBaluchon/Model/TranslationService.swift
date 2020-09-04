//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

class TranslationService: NetworkServices {
    static let shared = TranslationService()

    private var task: URLSessionDataTask?

    private let session: URLSession

    init(translationSession: URLSession = URLSession(configuration: .default)) {
        self.session = translationSession
        super.init()
    }

    private  let googleTranslateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2")

    func getTranslation(
        text: String,
        source: String,
        target: String,
        callback: @escaping (Utilities.ManageError, Translate?) -> Void) {

        guard let keyGoogleTranslate = Utilities.getValueForAPIKey(named: "API_GoogleTranslation") else { return }

        let queryItems = buildQueryItems(key: keyGoogleTranslate, text: text, source: source, target: target)

        let request = createRequest(url: googleTranslateUrl!, methode: "POST", queryItems: queryItems)

        task?.cancel()

        task = session.dataTask(with: request) { (data, response, error) in

            DispatchQueue.main.async {
                self.carryOutData(
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
