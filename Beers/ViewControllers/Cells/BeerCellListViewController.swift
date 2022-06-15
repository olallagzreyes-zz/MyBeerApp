//
//  BeerCellViewController.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 12/6/22.
//

import Foundation
import UIKit


class BeerCellViewController: UITableViewCell {
    
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var beerBrewedDateLabel: UILabel!
    
    override class func awakeFromNib() {
    }
    
    
    // Setup the cell view
    func setup(beer: Beer) {
        beerNameLabel.text = beer.name
        beerDescription.text = beer.tag
        abvLabel.text = "\(beer.abv ?? 0) %"
        beerBrewedDateLabel.text = beer.firstBrewedDate
        if let url = beer.imageURL {
            getImage(url: URL(string: url)!)
        } else {
            getImage(url: URL(string: Constants.URLS.MOCK_IMAGE_URL)!)
        }
    }
    
    
    // Get the image for the beer from an url
    func getImage(url: URL) {
        ImageLoader.shared.downloadImage(url: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.beerImage.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
