//
//  Utilities.swift
//  Movies Club
//
//  Created by Ahmed Refat on 18/08/2024.
//

import Foundation
import UIKit


class Utilities {
    
    static func navigateToDetailsScreen(viewController: UIViewController , movieID: Int){
        let controller = MovieDetailsViewController.instantiate()
        controller.movieID = movieID
        let navController = UINavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        viewController.present(navController, animated: true)
    }
}
