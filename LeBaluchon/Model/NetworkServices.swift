//
//  NetworkServices.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 02/09/2020. 
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import Foundation
class NetworkServices {
    ///build request for API
    func createRequest(url: URL, methode: String = "GET", queryItems: [URLQueryItem]) -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = queryItems
        var request = URLRequest(url: components.url!)
        request.httpMethod = methode
        return request
    }

    ///check URL response and manage errors
    func checkURLResponse(_ data: Data?,
                          _ response: URLResponse?,
                          _ error: Error?,
                          completionHandler: @escaping (Utilities.ManageError?) -> Void) {

        guard data != nil, error == nil else {
            completionHandler(.networkError)
            return
        }

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completionHandler(.httpResponseError)
            return
        }
        completionHandler(nil)
        return
    }

    ///generic data decodable function  with error management
    func decodeData<T: Decodable>(
        type: T?.Type,
        data: Data?,
        completionJSON: @escaping (T?, Utilities.ManageError?) -> Void) {
        #if DEBUG
        if let data = data {
            do {
                let decodedData =  try JSONDecoder().decode(type.self, from: data)
                return completionJSON(decodedData, nil)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("\nKey '\(key)' not found:", context.debugDescription)
                print("\ncodingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("\nValue '\(value)' not found:", context.debugDescription)
                print("\ncodingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("\nType '\(type)' mismatch:", context.debugDescription)
                print("\ncodingPath:", context.codingPath)
            } catch {
                print("\nerror: ", error)
            }
        }
        #else
        if let data = data {
            do {
                let decodedData =  try JSONDecoder().decode(type.self, from: data)
                return completionJSON(decodedData, nil)
            } catch {
                return completionJSON(nil, Utilities.ManageError.decodableIssue)
            }
        }
        #endif
        return completionJSON(nil, Utilities.ManageError.incorrectDataStruct)
    }
    ///generic data importation management
    func carryOutData<T: Decodable>(
        _ type: T?.Type,
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        completionHandler: @escaping (T?, Utilities.ManageError?) -> Void) {
        checkURLResponse(data, response, error, completionHandler: {[weak self] errorCode in
            if errorCode == nil {
                self?.decodeData(type: type.self,
                                 data: data,
                                 completionJSON: {(type, errorCode) in
                                    completionHandler(type, errorCode)
                })
            } else {
                completionHandler(nil, errorCode)
            }
        })
    }
}
