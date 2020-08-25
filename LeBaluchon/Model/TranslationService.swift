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
    
    private var translationSession = URLSession(configuration: .default)
    
    init(session: URLSession) {
        self.translationSession = session
    }
    
    private  let googleTranslateUrl = URL(string: "https://translation.googleapis.com/language/translate/v2")!
    
    func getTranslation(text: String, source: String, target: String, callback: @escaping (Bool, Translate?) -> Void) {
        let request = createTranslationRequest(text: text, source: source, target: target)
        
        task?.cancel()
        
        task = translationSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                
                guard let translate = try? JSONDecoder().decode(Translate.self, from: data) else {
                    callback(false, nil)
                    return
                }
                
                callback(true, translate)
            }
        }
        task?.resume()
    }
    
    private func createTranslationRequest(text: String, source: String, target: String) -> URLRequest {
        var components = URLComponents(url: googleTranslateUrl, resolvingAgainstBaseURL: false)!
        
        components.queryItems = [
            URLQueryItem(name: "key", value: "AIzaSyDkpFUqtuBa96oLuy9iC1ZrDpaQH1qo_iE"),
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "target", value: target),
            URLQueryItem(name: "format", value: "text")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        return request
    }
}
