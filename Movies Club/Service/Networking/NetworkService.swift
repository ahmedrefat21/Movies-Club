//
//  NetworkService.swift
//  Movies Club
//
//  Created by Ahmed Refat on 11/08/2024.
//

import Foundation


struct NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    
    func fetchAllMovies(page :Int,completion: @escaping(Result<AllMovies, Error>) -> Void) {
        request(route: .fetchAllMovies(page), completion: completion)
    }
    
    func fetchMovieDetails(id : Int,completion: @escaping(Result<MovieDetail, Error>) -> Void) {
        request(route: .fetchMovieDetails(id), completion: completion)
    }
    
    
    func request<T: Decodable>(route: Route, completion: @escaping (Result<T, Error>) -> Void) {
            let urlString = Route.baseUrl + route.description
            guard let url = URL(string: urlString) else { return }

            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else { return }

                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(T.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(jsonData))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
            dataTask.resume()
        }
}
