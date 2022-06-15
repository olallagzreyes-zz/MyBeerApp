//
//  Beer.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 10/6/22.
//

import UIKit

struct Beer: Codable {
    
    var id: Int
    var name: String
    var tag: String
    var firstBrewedDate: String
    var description: String
    var imageURL: String?
    var abv: Double?
    var ibu: Double?
    var food: [String]
    var tips: String
    var authorContributed: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case tag = "tagline"
        case firstBrewedDate = "first_brewed"
        case description
        case imageURL = "image_url"
        case abv
        case ibu
        case food = "food_pairing"
        case tips = "brewers_tips"
        case authorContributed = "contributed_by"
    }
    
    var author: String {
        authorContributed.components(separatedBy: "<")[0]
    }
}
