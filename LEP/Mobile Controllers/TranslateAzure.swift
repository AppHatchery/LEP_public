//
//  TranslateAzure.swift
//  LEP
//
//  Created by Yago Arconada on 10/22/23.
//

import Foundation

let subscriptionKey = "YOUR-SUBSCRIPTION-KEY" // May need to be reviewed for Translate Resource
let location = "eastus"
let endpoint = "https://api.cognitive.microsofttranslator.com/translate"

func makeRequest(requestText: String, inputLanguage: String, targetLanguage: String, completion: @escaping (Result<String, Error>) -> Void) {
    
    let parameters: [String: Any] = [
        "api-version": "3.0",
        "from": inputLanguage,
        "to": targetLanguage,
        "alignment": true
    ]
    
    let requestData: [[String: Any]] = [
        ["text": requestText]
    ]
    
    var urlComponents = URLComponents(string: endpoint)
    urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

    if let requestURL = urlComponents?.url {
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(subscriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(location, forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        request.addValue(UUID().uuidString, forHTTPHeaderField: "X-ClientTraceId")
        
        // Convert requestData to JSON data
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
        } catch {
            print("Error encoding request data: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        // Parsing successful, handle the JSON response
                        if let translation = jsonObject.first?["translations"] as? [[String: Any]] {
                            if let translatedText = translation.first?["text"] as? String {
                                completion(.success(translatedText))
                            } else {
                                let decodingError = NSError(domain: "Translation", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to parse translated text"])
                                completion(.failure(decodingError))
                            }
                        } else {
                            let decodingError = NSError(domain: "Translation", code: 2, userInfo: [NSLocalizedDescriptionKey: "Unable to parse translations"])
                            completion(.failure(decodingError))
                        }
                    } else {
                        let responseString = String(data: data, encoding: .utf8) ?? "Unable to convert data to a string"
                        let decodingError = NSError(domain: "Translation", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON Response: \(responseString)"])
                        completion(.failure(decodingError))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    } else {
        let invalidURLError = NSError(domain: "Translation", code: 4, userInfo: [NSLocalizedDescriptionKey: "Invalid request URL"])
        completion(.failure(invalidURLError))
    }
}
