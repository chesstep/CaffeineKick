//
//  NetworkManager.swift
//  CaffeineKick
//
//  Created by Chesley Stephens on 12/23/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

import Foundation

enum ModelRequestResult<Model> {
    case success(Model?)
    case failure(Error)
}

enum HTTPMethod: String {
    case GET
}

typealias ModelRequestCompletion = (ModelRequestResult<Decodable>) -> Void

class NetworkManager {
    
    var session: URLSession!
    
    init() {
        session = URLSession.shared
    }
    
    func get<T: Decodable>(endpoint: String, parameters: [String: Any]?, responseModel: T.Type, completion: ModelRequestCompletion?) {
        if let url = URL(string: endpoint), let httpMethod = HTTPMethod(rawValue: "GET") {
            executeRequest(url: url, httpMethod: httpMethod, parameters: parameters, responseModel: responseModel, completion: completion)
        } else {
            let error = NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Bad URL"]) as Error
            completion?(.failure(error))
        }
    }
}

// MARK: - Request

extension NetworkManager {
    
    private func executeRequest<T: Decodable>(url: URL, httpMethod: HTTPMethod, parameters: [String: Any]?, responseModel: T.Type, completion: ModelRequestCompletion?) {
        
        let request = self.generateRequest(url: url, httpMethod: httpMethod, parameters: parameters)
        let task = self.dataTask(request: request, responseModel: responseModel, completion: completion)
        task.resume()
    }
    
    func generateRequest(url: URL, httpMethod: HTTPMethod, parameters: [String: Any]?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        if let parameters = parameters {
            request = formatRequestParameters(request: request, parameters: parameters)
        }
        
        return request
    }
}

// MARK: - Model Task Creation

extension NetworkManager {
    
    func dataTask<T: Decodable>(url: URL, httpMethod: HTTPMethod, parameters: [String: Any]?, responseModel: T.Type, completion: ModelRequestCompletion?) -> URLSessionDataTask {
        let request = generateRequest(url: url, httpMethod: httpMethod, parameters: parameters)
        return dataTask(request: request, responseModel: responseModel, completion: completion)
    }
    
    func dataTask<T: Decodable>(request: URLRequest, responseModel: T.Type, completion: ModelRequestCompletion?) -> URLSessionDataTask {
        let task = self.session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion?(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                completion?(.failure(error))
                return
            }
            
            do {
                try self?.validateResponse(response: response, data: data)
            } catch {
                print(error.localizedDescription)
                completion?(.failure(error))
                return
            }
            
            do {
                let dataObject = try JSONDecoder().decode(responseModel, from: data)
                completion?(.success(dataObject))
                return
            } catch {
                print(error.localizedDescription)
            }
            
            completion?(.success(nil))
        }
        return task
    }
}

// MARK: - Error Handling

extension NetworkManager {
    
    func validateResponse(response: URLResponse?, data: Data?) throws {
        var errorMessage: NSString = "Invalid Response"
        guard let response = response as? HTTPURLResponse else {
            throw NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessage]) as Error
        }
        
        if response.statusCode < 200 || response.statusCode >= 300 {
            errorMessage = "Invalid Status Code"
            if let data = data, data.count > 0, let dataString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                errorMessage = dataString
            }
            throw NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessage]) as Error
        }
    }
}

// MARK: - Parameter Encoding

extension NetworkManager {
    
    func formatRequestParameters(request: URLRequest, parameters: [String: Any]?) -> URLRequest {
        var request = request
        guard let parameters = parameters else {
            return request
        }
        if request.httpMethod == HTTPMethod.GET.rawValue {
            var parametersString = httpParametersString(parameters: parameters)
            
            if parametersString.count > 0 {
                parametersString = "?" + urlEncode(string: parametersString)
            }
            if let url = request.url {
                let urlStringWithParameters = url.absoluteString + parametersString
                request.url = URL(string: urlStringWithParameters)!
            }
        }
        return request
    }
    
    func urlEncode(string: String) -> String {
        var urlEncodedString = ""
        if let encodedString = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            urlEncodedString = encodedString
        }
        return urlEncodedString
    }
    
    func httpParametersString(parameters: [String: Any]) -> String {
        var parametersString = ""
        let parameterKeys = Array(parameters.keys)
        for index in 0..<parameterKeys.count {
            let parameterKey = parameterKeys[index]
            if let parameterValue = parameters[parameterKey] {
                parametersString = "\(parametersString)\(parameterKey)=\(parameterValue)"
                
                if index + 1 < parameterKeys.count {
                    parametersString.append("&")
                }
            }
        }
        return parametersString
    }
}
