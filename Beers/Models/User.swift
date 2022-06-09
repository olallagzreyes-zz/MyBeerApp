//
//  User.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 9/6/22.
//

import Foundation


struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var twitterHandle: String
    var gitHubUsername: String
}

extension User {
    struct NetworkResponse: Codable {
        var result: User
    }
}
