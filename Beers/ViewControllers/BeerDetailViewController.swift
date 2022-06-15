//
//  BeerDetailViewController.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 13/6/22.
//

import Foundation
import UIKit

class BeerDetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var abvView: UIView!
    @IBOutlet weak var abvLabel: UILabel!
    @IBOutlet weak var ibuView: UIView!
    @IBOutlet weak var ibuLabel: UILabel!
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerTagLabel: UILabel!
    @IBOutlet weak var beerAuthorLabel: UILabel!
    @IBOutlet weak var beerDateLabel: UILabel!
    @IBOutlet weak var beerDescriptionLabel: UILabel!
    
    @IBOutlet weak var foodStack: UIStackView!
    
    @IBOutlet weak var beerTipLabel: UILabel!
    
    private var beers: [Beer] = []
    private var service: BeerService = BeerService()
    
    weak var coordinator: AppCoordinator?
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupData()
    }
    
    // Setup the UI
    func setupViews() {
        abvView.layer.cornerRadius = 10
        ibuView.layer.cornerRadius = 10
    }
    
    // Setup the data
    func setupData() {
        guard let beer = beer else { return }
        
        abvLabel.text = "Alc. \(beer.abv ?? 0)%"
        ibuLabel.text = "\(beer.ibu ?? 0) IBU"
        
        beerNameLabel.text = beer.name
        beerTagLabel.text = beer.tag
        beerAuthorLabel.text = beer.author
        beerDateLabel.text = beer.firstBrewedDate
        beerDescriptionLabel.text = beer.description
        
        createFoodStackItems(items: beer.food)
        getBeerImage(beer: beer)
    }
    
    // Create dynamically views to the StackFood
    func createFoodStackItems(items: [String]) {
        for item in items {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            stackView.spacing = 10
            stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            let imageView = UIImageView()
            imageView.tintColor = .orange
            imageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
            imageView.image = UIImage(systemName: Constants.ICONS.BEER_DETAIL_ICON)

            let textLabel = UILabel()
            textLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
            textLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            textLabel.numberOfLines = 0
            textLabel.font = UIFont.systemFont(ofSize: 12.0)
            textLabel.textAlignment = .natural
            textLabel.text = item
            
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(textLabel)
            foodStack.addArrangedSubview(stackView)
            foodStack.translatesAutoresizingMaskIntoConstraints = false
        }
    }
        
    // Get the image of the beer
    func getBeerImage(beer: Beer) {
        
        var url: URL
        if let beerUrl = beer.imageURL {
            url = URL(string: beerUrl)!
        }
        else {
            url = URL(string: Constants.URLS.MOCK_IMAGE_URL)!
        }
        
        ImageLoader.shared.downloadImage(url: url) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.beerImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
