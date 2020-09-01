//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 18/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation

class TranslationService {
    static let shared = TranslationService()
    private init() {}

    private var task: URLSessionDataTask?

    var session = URLSession(configuration: .default)

    private var queryItems: [String: String?] =
        ["key": nil,
         "q": nil,
         "source": nil,
         "target": nil
    ]

    init(translationSession: URLSession) {
        self.session = translationSession
    }

    private  let googleTranslateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2")!

    func getTranslation(text: String, source: String, target: String, callback: @escaping (Bool, Translate?) -> Void) {
        let keyGoogleTranslate = Utilities.getValueForAPIKey(named: "API_GoogleTranslation")

        queryItems["key"] = keyGoogleTranslate
        queryItems["q"] = text
        queryItems["source"] = source
        queryItems["target"] = target
        let request = Utilities.createRequest(url: googleTranslateUrl, methode: "POST", queryItems: queryItems)

        task?.cancel()

        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }

                guard let translate = try? JSONDecoder().decode(Translate?.self, from: data) else {
                    callback(false, nil)
                    return
                }
                callback(true, translate)
            }
        }
        task?.resume()
    }
}
