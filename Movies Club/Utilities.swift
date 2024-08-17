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
    
    
    
    static func formatDateString(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        dateFormatter.dateFormat = "d MMMM yyyy"
        let formattedDateString = dateFormatter.string(from: date)
        return formattedDateString
    }
}
