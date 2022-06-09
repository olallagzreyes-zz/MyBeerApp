//
//  NetworkResponse.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 9/6/22.
//

import Foundation

struct NetworkResponse<Wrapped: Decodable>: Decodable {
    var result: Wrapped
}

