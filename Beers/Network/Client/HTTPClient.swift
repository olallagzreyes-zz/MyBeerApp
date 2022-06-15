//
//  URLSession+Ext.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 13/6/22.
//

import Foundation

protocol HTTPClientProtocol {
    typealias Parameters = [String: Any]
    func createParams(page:Int?, per_page: Int?, parameters: Parameters?) -> Parameters
    func requestWithParams<T: Codable>(request: URLRequest,parameters: [String : Any],expection: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class HTTPClient: HTTPClientProtocol {
    
    static let shared: HTTPClient = HTTPClient()
    
    // Create the params to execute the request
    func createParams(page:Int?, per_page: Int?, parameters: Parameters?) -> Parameters {
        var params: Parameters = [:]
        
        if let page = page, let per_page = per_page {
            params = ["page": page, "per_page": per_page]
        }
        
        guard let newParams = parameters else { return params }
        
        for (key, value) in newParams {
            params[key] = value
        }
        return params
    }
    
    // Request to the api with Params
    func requestWithParams<T: Codable>(request: URLRequest,parameters: [String : Any],expection: T.Type,
                                       completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = request.url else { return }
        
        var urlReq = URLRequest(url: url)
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            let params = parameters.map { k,v in
                return URLQueryItem(name: k, value: "\(v)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
            }
            
            urlComponents.queryItems? = params
            urlReq.url = urlComponents.url
            
        } else {
            urlReq.url = request.url
        }
           
            
            let task = URLSession.shared.dataTask(with: urlReq) { data, response, error in
                guard let data = data else {
                    if let error = error {
                        completion(.failure(.generic(error)))
                    } else {
                        completion(.failure(.cancelled))
                    }
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(expection, from: data)
                    completion(.success(result))
                }
                catch {
                    print(error)
                    completion(.failure(.generic(error)))
                }
            }
            task.resume()
        }
    
}


