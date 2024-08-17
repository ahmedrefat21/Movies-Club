//
//  Route.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import Foundation


enum Route {
    static let baseUrl = "https://api.themoviedb.org/3/movie/"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500"
    static let apiKey = "Your API key"
    case fetchAllMovies(Int)
    case fetchMovieDetails(Int)
    
    
    var description: String {
        switch self {
        case .fetchAllMovies(let page):
            return "popular?api_key=\(Route.apiKey)&language=en-US&page=\(page)"
        case .fetchMovieDetails(let movieId):
            return "\(movieId)?api_key=\(Route.apiKey)&language=en-US"
        }
    }
}
