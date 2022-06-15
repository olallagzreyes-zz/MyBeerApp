//
//  NetworkError.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 15/6/22.
//

import UIKit

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case notFound
}
