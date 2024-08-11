//
//  AllMovies.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import Foundation


struct AllMovies : Decodable {
    var page: Int
    var results: [Movie]
    var totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

