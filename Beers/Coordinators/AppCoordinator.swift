//
//  AppCoordinator.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 13/6/22.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    // Go to the main window, the beer search/list view
    func start() {
        let vc = BeersListViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    // Go to the beer detail page
    func showDetails(beer: Beer) {
        let vc = BeerDetailViewController.instantiate()
        vc.coordinator = self
        vc.beer = beer
        navigationController.present(vc, animated: true)
    }
}


