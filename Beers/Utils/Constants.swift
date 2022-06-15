//
//  Constants.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 12/6/22.
//

import Foundation

struct Constants {
    
    struct STORYBOARD {
        public static let NAME = "Beers"
    }
    
    struct CELLS {
        public static let CELL_BEER = "BeerCellViewController"
        public static let CELL_BEER_XIB_NAME = "BeerCell"
    }
    
    struct URLS {
        public static var BASE_URL = "https://api.punkapi.com/v2/"
        public static var ALL_BEERS = "\(BASE_URL)beers"
        public static var RANDOM_BEER = "\(ALL_BEERS)/random"
        public static var MOCK_IMAGE_URL = "https://images.punkapi.com/v2/41.png"
    }
    
    struct ICONS {
        public static var BEER_DETAIL_ICON = "staroflife.circle.fill"
    }
    
    struct PAGINATION {
        public static var PAGE = 1
        public static var ITEMS_PER_PAGE = 10
    }
    
    struct REFRESH {
        public static var REFRESH_TITLE = "Pull to get more beers!"
    }
    
    struct FILTERS {
        public static var FOOD = "food"
        public static var ABV = "abv_lt"
        public static var BEER_NAME = "beer_name"
        
        struct PLACEHOLDER {
            public static var NONE = "No filter selected"
            public static var FOOD = "Search by food: "
            public static var ABV  = "Search for abv with less than : "
            public static var BEER_NAME = "Search by beer name: "
        }
    }
}
