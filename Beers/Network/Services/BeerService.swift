//
//  MoviesService.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 10/6/22.
//

import Foundation

protocol BeersServiceProtocol {
    func getBeers(withParameters parameters: [String:Any], completion: @escaping (Result<[Beer], Error>) -> Void)
    func getRandomBeer(url: String, completion: @escaping (Result<Beer, Error>) -> Void)
}

struct BeerService: BeersServiceProtocol {
    // Get a random beer
    func getRandomBeer(url: String, completion: @escaping (Result<Beer, Error>) -> Void) {
        HTTPClient.shared.requestWithParams(request: URLRequest(url: URL(string: Constants.URLS.RANDOM_BEER)!), parameters: [:], expection: [Beer].self) { result in
            switch result {
            case .success(let beers):
                if let _ = beers.count > 0, let beer = beers.first {
                    return completion(.success(beer))
                } else {
                    return completion(.failure(NetworkError.notFound))
                }
              
                
            case .failure(let error):
                print(error)
                return completion(.failure(error))
            }
        }
    }
    
    // Get the beers by parameters
    func getBeers(withParameters parameters: [String : Any], completion: @escaping (Result<[Beer], Error>) -> Void) {
        HTTPClient.shared.requestWithParams(request: URLRequest(url: URL(string: Constants.URLS.ALL_BEERS)!), parameters: parameters, expection: [Beer].self) { result in
            switch result {
            case .success(let beers):
                completion(.success(beers))
                return
            case .failure(let error):
                print(error)
                return completion(.failure(error))
            }
        }
    }
}

