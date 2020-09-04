//
//  NetworkServices.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 02/09/2020. 
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation
class NetworkServices {

    func createRequest(url: URL, methode: String = "GET", queryItems: [URLQueryItem]) -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = methode
        return request
    }

    func checkURLResponse(_ data: Data?,
                          _ response: URLResponse?,
                          _ error: Error?,
                          completionHandler: @escaping (Utilities.ManageError) -> Void) {

        guard data != nil, error == nil else {
            completionHandler(.networkError)
            return
        }

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completionHandler(.httpResponseError)
            return
        }
        completionHandler(.none)
        return
    }

    func decodeData<T: Decodable>(
        type: T?.Type,
        data: Data?,
        completionHandler: @escaping (T?, Utilities.ManageError) -> Void) {

        guard let decodedData = try? JSONDecoder().decode(type.self, from: data!)
            else {
                completionHandler(nil, .incorrectDataStruct)
                return
        }
        return completionHandler(decodedData, .none)
    }

    func carryOutData<T: Decodable>(
        _ type: T?.Type,
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        completionHandler: @escaping (T?, Utilities.ManageError) -> Void) {
        self.checkURLResponse(data, response, error, completionHandler: { errorCode in
            if errorCode == .none {
                self.decodeData(type: type.self,
                                data: data,
                                completionHandler: { (type, errorCode) in
                                    completionHandler(type, errorCode)
                })
            } else {
                completionHandler(nil, errorCode)
            }
        })

    }
}
