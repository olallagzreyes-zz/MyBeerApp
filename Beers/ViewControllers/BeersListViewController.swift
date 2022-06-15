//
//  ViewController.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 8/6/22.
//

import UIKit

// Enum for configuration the filters in the beers searching
enum FilterBeer: String, CaseIterable  {
    case none = "NONE"
    case food = "FOOD"
    case abv  = "ABV"
    case beerName = "BEER NAME"
    
    
    // Configure the parameters for the HTTPClient calls
    func getParameter(page: Int, per_page: Int, filter: Any = "") -> [String: Any] {
        switch self {
        case .none:
            return HTTPClient.shared.createParams(page: page, per_page: per_page, parameters: [:])
        case .food:
            return HTTPClient.shared.createParams(page: page, per_page: per_page, parameters: [Constants.FILTERS.FOOD: filter])
        case .abv:
            return HTTPClient.shared.createParams(page: page, per_page: per_page, parameters: [Constants.FILTERS.ABV: filter])
        case .beerName:
            return HTTPClient.shared.createParams(page: page, per_page: per_page, parameters: [Constants.FILTERS.BEER_NAME: filter])
        }
    }
    
    func localizedString() -> String {
        return self.rawValue
    }
    
    // Get the key throught the value
    static func fromLocalizedString(localizedString: String) -> FilterBeer? {
        for type in FilterBeer.allCases {
            if type.localizedString() == localizedString {
                return type
            }
        }
        return nil
    }
}


class BeersListViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var beerTable: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultsView: UIView!
    
    private var beers: [Beer] = []
    private var service: BeerService = BeerService()
    
    weak var coordinator: AppCoordinator?
    private let refreshControl = UIRefreshControl()
    private var searchTerm: String = ""
    
    private var pickerTitles: [String] {
        return FilterBeer.allCases.map { filter in
            filter.rawValue
        }
    }
    
    private var page = Constants.PAGINATION.PAGE
    private var itemsPage = Constants.PAGINATION.ITEMS_PER_PAGE
    private var filterType: FilterBeer = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // Refresh the table with a new page with results
    @objc func refresh(_ sender: AnyObject) {
        page += 1
        
        switch filterType {
        case .none:
            getBeers(parameters: filterType.getParameter(page: page, per_page: itemsPage), isUpdating: true)
        case .food:
            getBeers(parameters: filterType.getParameter(page: page, per_page: itemsPage, filter: searchTerm), isUpdating: true)
        case .abv:
            getBeers(parameters: filterType.getParameter(page: page, per_page: itemsPage, filter: searchTerm), isUpdating: true)
        case .beerName:
            getBeers(parameters: filterType.getParameter(page: page, per_page: itemsPage), isUpdating: true)
        }
        refreshControl.endRefreshing()
    }
    
    // Configure the view
    func setup() {
        refreshControl.attributedTitle = NSAttributedString(string: Constants.REFRESH.REFRESH_TITLE)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        beerTable.addSubview(refreshControl)
        
        beerTable.register(UINib(nibName: Constants.CELLS.CELL_BEER_XIB_NAME, bundle: nil), forCellReuseIdentifier: Constants.CELLS.CELL_BEER_XIB_NAME)
        beerTable.delegate = self
        beerTable.dataSource = self
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        searchBar.placeholder = filterType.rawValue
        searchBar.delegate = self
        getBeers(parameters: filterType.getParameter(page: page, per_page: itemsPage), isUpdating: false)
    }
    
    // Change the placeholder of the SearchBar
    func changeSearchBarPlaceholder() -> String {
        switch filterType {
        case .none:
            return Constants.FILTERS.PLACEHOLDER.NONE
        case .food:
            return Constants.FILTERS.PLACEHOLDER.FOOD
        case .abv:
            return Constants.FILTERS.PLACEHOLDER.ABV
        case .beerName:
            return Constants.FILTERS.PLACEHOLDER.BEER_NAME
        }
    }
    
    // Show or hide the table or noResultsView
    func showBeers(exists: Bool) {
        DispatchQueue.main.async {
            if exists {
                self.beerTable.isHidden = false
                self.noResultsView.isHidden = true
            } else {
                self.beers = []
                self.beerTable.isHidden = true
                self.noResultsView.isHidden = false
            }
            self.beerTable.reloadData()
        }
    }
    
    // Get the beers from the HTTPClient
    func getBeers(parameters: [String: Any], isUpdating: Bool) {
        service.getBeers(withParameters: parameters) { result in
            switch result {
            case .success(let beers):
                DispatchQueue.main.async {
                    if !beers.isEmpty {
                        if isUpdating {
                            self.beers.append(contentsOf: beers)
                            self.refreshControl.endRefreshing()
                        } else {
                            self.beers = beers
                        }
                        self.showBeers(exists: true)
                    } else {
                        if !isUpdating {
                            self.showBeers(exists: false)
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.showBeers(exists: false)
            }
        }
    }
    
    
    // Get a random beer and open its detail
    @IBAction func getRandomBeer(_ sender: Any) {
        filterType = .none
        page = Constants.PAGINATION.PAGE
        itemsPage = Constants.PAGINATION.ITEMS_PER_PAGE
        
        service.getRandomBeer(url: Constants.URLS.RANDOM_BEER) { result in
            switch result {
            case .success(let beer):
                DispatchQueue.main.async {
                    self.coordinator?.showDetails(beer: beer)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension BeersListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,
                                   UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTitles[row]
    }
    
    // Change the filter type and update the searchBar placeholder
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterType = FilterBeer.fromLocalizedString(localizedString: self.pickerTitles[row]) ?? .none
        if filterType == .none {
            searchBar.isUserInteractionEnabled = false
            getBeers(parameters: filterType.getParameter(page: page, per_page: itemsPage), isUpdating: false)
        } else {
            searchBar.isUserInteractionEnabled = true
        }
        searchTerm = ""
        searchBar.text = ""
        searchBar.placeholder = changeSearchBarPlaceholder()
    }
    
    
    
    // Search a Beer if its something written in the searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText
        if searchText.isEmpty {
            page = Constants.PAGINATION.PAGE
            itemsPage = Constants.PAGINATION.ITEMS_PER_PAGE
            showBeers(exists: false)
            searchBar.text = ""
        } else {
            page = Constants.PAGINATION.PAGE
            itemsPage = Constants.PAGINATION.ITEMS_PER_PAGE
            getBeers(parameters: self.filterType.getParameter(page: page, per_page: itemsPage, filter: searchTerm), isUpdating: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    // Draw the info in each cell of the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELLS.CELL_BEER_XIB_NAME, for: indexPath) as! BeerCellViewController
        cell.setup(beer: self.beers[indexPath.row])
        return cell
    }
    
    // Navigate to beer´s detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetails(beer: self.beers[indexPath.row])
    }
    
    
}
