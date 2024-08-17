//
//  MovieCell.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import UIKit
import Cosmos
import Kingfisher

class MovieCell: UITableViewCell {

    // MARK: Identifier
    static let identifier = String(describing: MovieCell.self)
    
    // MARK: - Outlets
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieTotalRating: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieRatinginStars: CosmosView!
    
    
    // MARK: - Cell Configuration
    func setup(movie : Movie)  {
        movieTitle.text = movie.originalTitle
        movieTotalRating.text = String(format: "%.1f", movie.voteAverage ?? 0)
        movieImg.kf.setImage(with: URL(string: Route.imageBaseUrl + (movie.posterPath ?? "")))
        movieReleaseDate.text = Utilities.formatDateString(movie.releaseDate ?? "")  
        movieRatinginStars.rating = Double((movie.voteAverage ?? 0) / 2)
    }
    
    func setupFavouriteList(movie : LocalMovie)  {
        movieTitle.text = movie.title
        movieTotalRating.text = String(format: "%.1f", movie.rating)
        movieImg.kf.setImage(with: URL(string: Route.imageBaseUrl + (movie.image)))
        movieReleaseDate.text = Utilities.formatDateString(movie.releaseDate)
        movieRatinginStars.rating = Double((movie.rating) / 2)
    }
    
}
